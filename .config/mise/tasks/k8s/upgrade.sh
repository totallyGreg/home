#!/usr/bin/env bash
#MISE description="Upgrade Kubernetes cluster-wide via talosctl upgrade-k8s. Gates on cluster:status. Bump one minor at a time."
#USAGE arg "<version>" help="Target Kubernetes version, e.g. v1.36.1 or v1.37.0" env="K8S_TARGET"
set -euo pipefail
# Global file tasks execute with $PWD outside the project (mise sets MISE_ORIGINAL_CWD
# instead of preserving $PWD). Nested `mise run` calls (cluster:status below) re-resolve
# project [env] from $PWD, so without this cd they silently lose TALOSCONFIG/TALOS_ENDPOINT
# and the quorum gate falsely reports unhealthy.
cd "${MISE_ORIGINAL_CWD}" || exit 1

# Outside a cluster project mise resolves no [env] and stale values leak in from the
# ambient login shell — which would point this rolling upgrade at the wrong cluster.
# Drop the ambient values, then trust only what mise resolves here.
unset TALOSCONFIG TALOS_ENDPOINT TALOS_ENDPOINTS
eval "$(mise env 2>/dev/null | grep -E '^export (TALOSCONFIG|TALOS_ENDPOINTS?)=' || true)"
: "${TALOSCONFIG:?no cluster env resolved at ${MISE_ORIGINAL_CWD} — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set in the active profile [env]}"

VERSION="${usage_version}"

echo "==> Pre-flight: quorum gate"
if ! mise run cluster:status; then
  echo "ERROR: cluster not healthy — refusing to start a K8s upgrade. Resolve first." >&2
  exit 1
fi

# Drive upgrade-k8s through a control-plane node's own IP, not the VIP. upgrade-k8s
# restarts kube-apiserver on every control-plane node, and the VIP follows apiserver
# health — so with the VIP as endpoint/node the session can move or drop mid-run
# (2026-10-22: the same VIP drop broke a Talos upgrade's --wait stream). A node's
# Talos API (apid) stays up while its apiserver restarts, and upgrade-k8s run against
# any one control-plane node upgrades all of them.
K8S_EP=""
for cand in $(kubectl get nodes -l node-role.kubernetes.io/control-plane -o json 2>/dev/null \
    | jq -r '.items[].status.addresses[] | select(.type=="InternalIP") | .address'); do
  if talosctl --talosconfig "${TALOSCONFIG}" -e "${cand}" -n "${cand}" version >/dev/null 2>&1; then
    K8S_EP="${cand}"; break
  fi
done
if [[ -z "${K8S_EP}" ]]; then
  K8S_EP="${TALOS_ENDPOINTS:-${TALOS_ENDPOINT}}"
  echo "  ⚠ no control-plane node answers the Talos API directly — falling back to ${K8S_EP}"
fi

echo "==> Upgrading Kubernetes → ${VERSION} via ${K8S_EP} (rolling control-plane + kubelets)..."
talosctl --talosconfig "${TALOSCONFIG}" -e "${K8S_EP}" -n "${K8S_EP}" \
  upgrade-k8s --to "${VERSION}"

echo "==> Post-upgrade versions:"
kubectl get nodes -o custom-columns='NODE:.metadata.name,K8S:.status.nodeInfo.kubeletVersion'
mise run cluster:status

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
unset TALOSCONFIG TALOS_ENDPOINT
eval "$(mise env 2>/dev/null | grep -E '^export (TALOSCONFIG|TALOS_ENDPOINT)=' || true)"
: "${TALOSCONFIG:?no cluster env resolved at ${MISE_ORIGINAL_CWD} — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set in the active profile [env]}"

VERSION="${usage_version}"

echo "==> Pre-flight: quorum gate"
if ! mise run cluster:status; then
  echo "ERROR: cluster not healthy — refusing to start a K8s upgrade. Resolve first." >&2
  exit 1
fi

echo "==> Upgrading Kubernetes → ${VERSION} (rolling control-plane + kubelets)..."
talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${TALOS_ENDPOINT}" \
  upgrade-k8s --to "${VERSION}"

echo "==> Post-upgrade versions:"
kubectl get nodes -o custom-columns='NODE:.metadata.name,K8S:.status.nodeInfo.kubeletVersion'
mise run cluster:status

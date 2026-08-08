#!/usr/bin/env bash
#MISE description="Upgrade Talos in place on ONE node to TALOS_VERSION (reboots ~2 min; data preserved). Gates on cluster:status; no-op if already current."
#USAGE arg "<ip>" help="Mgmt IP of the node to upgrade (e.g. 10.0.0.18)" env="UPGRADE_IP"
set -euo pipefail
# Global file tasks execute with $PWD outside the project (mise sets MISE_ORIGINAL_CWD
# instead of preserving $PWD). Nested `mise run` calls (cluster:status below) re-resolve
# project [env] from $PWD, so without this cd they silently lose TALOSCONFIG/TALOS_ENDPOINT
# and the quorum gate falsely reports unhealthy.
cd "${MISE_ORIGINAL_CWD}" || exit 1

# Outside a cluster project mise resolves no [env] and stale values leak in from the
# ambient login shell — which would point this upgrade (and its reboot) at the wrong
# node. Drop the ambient values, then trust only what mise resolves here.
unset TALOSCONFIG TALOS_ENDPOINT TALOS_VERSION CLUSTER_PATCHES
eval "$(mise env 2>/dev/null | grep -E '^export (TALOSCONFIG|TALOS_ENDPOINT|TALOS_VERSION|CLUSTER_PATCHES)=' || true)"
: "${TALOSCONFIG:?no cluster env resolved at ${MISE_ORIGINAL_CWD} — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set in the active profile [env]}" \
  "${TALOS_VERSION:?not set in the active profile [env]}" \
  "${CLUSTER_PATCHES:?not set in the active profile [env]}"

IP="${usage_ip}"

CUR=$(talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${IP}" version 2>/dev/null \
  | awk '/Server:/{s=1} s&&/Tag:/{print $2; exit}')
if [[ "${CUR}" == "${TALOS_VERSION}" ]]; then
  echo "  ✓ ${IP} already on Talos ${TALOS_VERSION} — nothing to do"
  exit 0
fi

echo "==> Pre-flight: quorum gate (the upgrade reboots ${IP})"
if ! mise run cluster:status; then
  echo "ERROR: cluster not healthy — refusing to reboot a node for upgrade. Resolve first." >&2
  exit 1
fi

SCHEMATIC_ID=$(curl -sX POST --data-binary @"${CLUSTER_PATCHES}/bare-metal.yaml" \
  https://factory.talos.dev/schematics | jq -r .id)
[[ -z "${SCHEMATIC_ID}" || "${SCHEMATIC_ID}" == "null" ]] && { echo "ERROR: no schematic ID"; exit 1; }

# Longhorn instance-manager PDBs have 0 allowed disruptions — they block kubectl drain.
NODE_NAME=$(kubectl get nodes -o json 2>/dev/null \
  | jq -r --arg ip "$IP" '.items[] | select(.status.addresses[] | select(.type=="InternalIP") | .address == $ip) | .metadata.name' || true)
if [[ -n "$NODE_NAME" ]]; then
  echo "==> Removing Longhorn instance-manager PDBs on ${NODE_NAME} (allows drain; rebuilt on return)..."
  IM_PODS=$(kubectl get pods -n longhorn-system \
    --field-selector "spec.nodeName=${NODE_NAME}" \
    -o jsonpath='{.items[?(@.metadata.labels.longhorn\.io/component=="instance-manager")].metadata.name}' 2>/dev/null || true)
  for pod in $IM_PODS; do
    kubectl delete pdb "$pod" -n longhorn-system --ignore-not-found 2>/dev/null && \
      echo "  ✓ deleted PDB ${pod}" || true
  done
fi

echo "==> Upgrading ${IP}: ${CUR:-unknown} → Talos ${TALOS_VERSION} (schematic ${SCHEMATIC_ID})..."
talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${IP}" upgrade \
  --image "factory.talos.dev/installer/${SCHEMATIC_ID}:${TALOS_VERSION}" --wait

if [[ -n "${NODE_NAME}" ]]; then
  echo "==> Waiting for ${NODE_NAME} to be Ready..."
  kubectl wait node/"${NODE_NAME}" --for=condition=Ready --timeout=300s
  kubectl uncordon "${NODE_NAME}"
  echo "  ✓ ${NODE_NAME} uncordoned"
fi

echo "==> Post-upgrade health:"
mise run cluster:status

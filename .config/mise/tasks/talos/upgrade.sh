#!/usr/bin/env bash
#MISE description="Upgrade Talos in place on ONE node to TALOS_VERSION + the schematic from bare-metal.yaml (reboots ~2 min; data preserved). Gates on cluster:status; no-op if version and schematic are current."
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

SCHEMATIC_ID=$(curl -sX POST --data-binary @"${CLUSTER_PATCHES}/bare-metal.yaml" \
  https://factory.talos.dev/schematics | jq -r .id)
[[ -z "${SCHEMATIC_ID}" || "${SCHEMATIC_ID}" == "null" ]] && { echo "ERROR: no schematic ID"; exit 1; }

# "Current" means version AND schematic. Comparing the version alone skipped a node
# whose extensions changed (2026-10-22: adding util-linux-tools, which Longhorn needs
# for fstrim, would never have reached a node already on TALOS_VERSION).
CUR_SCHEMATIC=$(talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${IP}" get extensions -o json 2>/dev/null \
  | jq -r 'select(.spec.metadata.name=="schematic") | .spec.metadata.version' || true)
if [[ "${CUR}" == "${TALOS_VERSION}" && "${CUR_SCHEMATIC}" == "${SCHEMATIC_ID}" ]]; then
  echo "  ✓ ${IP} already on Talos ${TALOS_VERSION}, schematic ${SCHEMATIC_ID:0:12}… — nothing to do"
  exit 0
fi
[[ "${CUR}" == "${TALOS_VERSION}" ]] && \
  echo "==> ${IP} is on ${TALOS_VERSION} but schematic ${CUR_SCHEMATIC:0:12}… ≠ ${SCHEMATIC_ID:0:12}… — upgrading to apply extensions"

echo "==> Pre-flight: quorum gate (the upgrade reboots ${IP})"
if ! mise run cluster:status; then
  echo "ERROR: cluster not healthy — refusing to reboot a node for upgrade. Resolve first." >&2
  exit 1
fi

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

# Drive the upgrade through a control-plane node that is NOT the one rebooting. With
# the VIP (or the target itself) as endpoint, the --wait stream dies when that node
# goes down: 2026-10-22, minix4 held the VIP, talosctl exited non-zero after "post
# check passed", and its own uncordon never ran — the node stayed cordoned and Longhorn
# could not place its instance-manager there. Talos docs: never use the VIP as the
# Talos API endpoint.
UPGRADE_EP=""
for cand in $(kubectl get nodes -l node-role.kubernetes.io/control-plane -o json 2>/dev/null \
    | jq -r '.items[].status.addresses[] | select(.type=="InternalIP") | .address'); do
  [[ "${cand}" == "${IP}" ]] && continue
  if talosctl --talosconfig "${TALOSCONFIG}" -e "${cand}" -n "${cand}" version >/dev/null 2>&1; then
    UPGRADE_EP="${cand}"; break
  fi
done
if [[ -z "${UPGRADE_EP}" ]]; then
  UPGRADE_EP="${TALOS_ENDPOINT}"
  echo "  ⚠ no other control-plane node answers the Talos API — falling back to ${UPGRADE_EP}; the --wait stream may drop at reboot"
fi

echo "==> Upgrading ${IP} via endpoint ${UPGRADE_EP}: ${CUR:-unknown} → Talos ${TALOS_VERSION} (schematic ${SCHEMATIC_ID})..."
talosctl --talosconfig "${TALOSCONFIG}" -e "${UPGRADE_EP}" -n "${IP}" upgrade \
  --image "factory.talos.dev/installer/${SCHEMATIC_ID}:${TALOS_VERSION}" --wait

if [[ -n "${NODE_NAME}" ]]; then
  echo "==> Waiting for ${NODE_NAME} to be Ready..."
  kubectl wait node/"${NODE_NAME}" --for=condition=Ready --timeout=300s
  kubectl uncordon "${NODE_NAME}"
  echo "  ✓ ${NODE_NAME} uncordoned"
fi

echo "==> Post-upgrade health:"
mise run cluster:status

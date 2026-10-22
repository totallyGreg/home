#!/usr/bin/env bash
#MISE description="Run talosctl health against the given control-plane nodes. Requires TALOSCONFIG + TALOS_ENDPOINT + NODES_CSV (comma-separated mgmt IPs)."
set -uo pipefail

: "${TALOSCONFIG:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${NODES_CSV:?Set NODES_CSV=<comma-separated control-plane IPs>}"

# Run the check from the first control-plane node that answers, not from the VIP —
# the VIP follows etcd/apiserver health, so it is missing exactly when this matters.
EP="${TALOS_ENDPOINTS:-${TALOS_ENDPOINT}}"
VIA="${TALOS_ENDPOINT}"
for n in ${NODES_CSV//,/ }; do
  talosctl --talosconfig "${TALOSCONFIG}" -e "${n}" -n "${n}" version >/dev/null 2>&1 && { VIA="${n}"; break; }
done
talosctl --talosconfig "${TALOSCONFIG}" \
  -e "${EP}" -n "${VIA}" health \
  --control-plane-nodes "${NODES_CSV}" 2>&1

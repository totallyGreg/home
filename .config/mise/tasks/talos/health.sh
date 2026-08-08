#!/usr/bin/env bash
#MISE description="Run talosctl health against the given control-plane nodes. Requires TALOSCONFIG + TALOS_ENDPOINT + NODES_CSV (comma-separated mgmt IPs)."
set -uo pipefail

: "${TALOSCONFIG:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${NODES_CSV:?Set NODES_CSV=<comma-separated control-plane IPs>}"

talosctl --talosconfig "${TALOSCONFIG}" \
  -e "${TALOS_ENDPOINT}" -n "${TALOS_ENDPOINT}" health \
  --control-plane-nodes "${NODES_CSV}" 2>&1

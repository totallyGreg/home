#!/usr/bin/env bash
#MISE description="Succinct cluster + etcd quorum verdict. Exit: 0=healthy, 10=degraded, 20=quorum lost. Composes talos:quorum + k8s:nodes + k8s:pods."
set -uo pipefail
# Global file tasks execute with $PWD outside the project (mise sets MISE_ORIGINAL_CWD
# instead of preserving $PWD). Nested `mise run` calls re-resolve project [env] from
# $PWD, so without this cd they silently lose TALOSCONFIG/TALOS_ENDPOINT and report
# false failures (e.g. "etcd unreachable") instead of erroring loudly.
cd "${MISE_ORIGINAL_CWD}" || exit 1

# The cd above only helps when MISE_ORIGINAL_CWD *is* a cluster project. Run from
# anywhere else and mise resolves no [env], so stale CLUSTER_NAME/TALOSCONFIG/
# TALOS_ENDPOINT leak in from the ambient login shell and we emit a confident but
# wrong verdict. Drop the ambient values, then trust only what mise resolves here.
unset CLUSTER_NAME TALOSCONFIG TALOS_ENDPOINT
eval "$(mise env 2>/dev/null | grep -E '^export (CLUSTER_NAME|TALOSCONFIG|TALOS_ENDPOINT)=' || true)"
: "${CLUSTER_NAME:?no cluster env resolved at ${MISE_ORIGINAL_CWD} — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}"

echo "Cluster: ${CLUSTER_NAME}"

NODES_OUT=$(mise run k8s:nodes 2>&1); NODES_EXIT=$?
QUORUM_OUT=$(mise run talos:quorum 2>&1); QUORUM_EXIT=$?
PODS_OUT=$(mise run k8s:pods 2>&1)

printf '%s\n' "${NODES_OUT}"
printf '%s\n' "${QUORUM_OUT}"
[[ -n "${PODS_OUT}" ]] && printf '%s\n' "${PODS_OUT}"

COMBINED_EXIT=$(( NODES_EXIT > QUORUM_EXIT ? NODES_EXIT : QUORUM_EXIT ))
case "${COMBINED_EXIT}" in
  0)  echo "QUORUM:  ✓ HEALTHY" ;;
  10) echo "QUORUM:  ⚠ DEGRADED — see above" ;;
  *)  echo "QUORUM:  ✗ LOST — see above" ;;
esac
exit "${COMBINED_EXIT}"

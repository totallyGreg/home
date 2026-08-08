#!/usr/bin/env bash
#MISE description="Report Failed and error-state pods across all namespaces. Informational only — always exits 0."
#MISE quiet=true
set -uo pipefail

POD_FAILED=$(kubectl get pods -A --field-selector status.phase=Failed --no-headers 2>/dev/null | wc -l | tr -d ' ')
POD_ERR=$(kubectl get pods -A --no-headers 2>/dev/null | awk '$4 ~ /CrashLoopBackOff|CreateContainerError|ImagePullBackOff|ErrImagePull|Error/' | wc -l | tr -d ' ')

if [[ "${POD_FAILED}" -gt 0 || "${POD_ERR}" -gt 0 ]]; then
  bits=()
  [[ "${POD_FAILED}" -gt 0 ]] && bits+=("${POD_FAILED} failed/unknown")
  [[ "${POD_ERR}" -gt 0 ]] && bits+=("${POD_ERR} need investigation")
  joined="${bits[0]}"
  for b in "${bits[@]:1}"; do joined="${joined} · ${b}"; done
  echo "Pods:    ${joined}"
fi
exit 0

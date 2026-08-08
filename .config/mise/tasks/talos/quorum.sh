#!/usr/bin/env bash
#MISE description="Talos etcd-only quorum verdict (prints an ETCD: line, not the whole cluster). Exit: 0=healthy, 10=degraded (quorate, reduced redundancy), 20=quorum lost. Requires TALOSCONFIG + TALOS_ENDPOINT."
#MISE quiet=true
set -uo pipefail

: "${TALOSCONFIG:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}" \
  "${TALOS_ENDPOINT:?not set — run from a cluster project directory, or activate a profile with MISE_ENV=<target>}"

MEMBERS=$(talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${TALOS_ENDPOINT}" etcd members 2>/dev/null || true)
MEMBER_IPS=$(printf '%s\n' "${MEMBERS}" | grep -oE 'https://[0-9.]+:2380' | sed -E 's#https://##; s#:2380##' | sort -u | paste -sd, -)
STATUS=""; ALARMS=""
if [[ -n "${MEMBER_IPS}" ]]; then
  STATUS=$(talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${MEMBER_IPS}" etcd status 2>/dev/null || true)
  ALARMS=$(talosctl --talosconfig "${TALOSCONFIG}" -e "${TALOS_ENDPOINT}" -n "${MEMBER_IPS}" etcd alarm list 2>/dev/null | grep -viE '^NODE|^$' || true)
fi

export MEMBERS STATUS ALARMS
python3 <<'PYEOF'
import os, re
from collections import Counter

members = os.environ.get("MEMBERS", "")
status  = os.environ.get("STATUS", "")
alarms  = os.environ.get("ALARMS", "").strip()

mem_ips  = sorted(set(re.findall(r'https://([0-9.]+):2380', members)))
N = len(mem_ips)
resp_ips = sorted(set(re.findall(r'(?m)^([0-9]{1,3}(?:\.[0-9]{1,3}){3})\b', status)))
R = len(resp_ips)
hexes  = re.findall(r'\b[0-9a-f]{16}\b', status)
leader = Counter(hexes).most_common(1)[0][0] if hexes else None

majority = (N // 2 + 1) if N else 0
headroom = R - majority

problems = []
if N == 0:
    problems.append("etcd unreachable (no members)")
elif R < majority:
    problems.append(f"{R}/{N} responding, need {majority}")
else:
    if R < N:  problems.append(f"{N - R} etcd member(s) down")
    if alarms: problems.append("etcd alarms present")

ld = f" · leader={leader[:8]}…" if leader else ""
al = "0 alarms" if not alarms else "ALARMS"
print(f"etcd:    {N} members · {R} responding{ld} · {al}")

if N == 0 or R < majority:
    for m in problems: print(f"           - {m}")
    print(f"ETCD:    ✗ LOST — " + "; ".join(problems))
    raise SystemExit(20)
elif problems:
    for m in problems: print(f"           - {m}")
    print(f"ETCD:    ⚠ DEGRADED — {R}/{N} responding (quorate, {max(headroom, 0)} headroom)")
    raise SystemExit(10)
else:
    print(f"ETCD:    ✓ HEALTHY — {R}/{N}, tolerates {headroom} failure(s)")
    raise SystemExit(0)
PYEOF

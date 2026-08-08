#!/usr/bin/env bash
#MISE description="Kubernetes node readiness verdict. Exit: 0=all Ready, 10=some NotReady."
#MISE quiet=true
set -uo pipefail

# An unreachable API server, a bad KUBECONFIG and an expired cert all used to be
# swallowed into an empty verdict that exited 0 — i.e. a dead cluster read green.
# Fail loudly instead: exit 20 (quorum-lost tier) so cluster:status escalates.
if ! NODES_JSON=$(kubectl get nodes -o json 2>&1); then
  echo "Nodes:   ✗ UNREACHABLE — kubectl get nodes failed"
  # kubectl repeats the same memcache warning per API group; the real cause is last.
  printf '%s\n' "${NODES_JSON}" | tail -2 | sed 's/^/           - /'
  exit 20
fi
export NODES_JSON
python3 <<'PYEOF'
import os, json

try:
    items = json.loads(os.environ["NODES_JSON"]).get("items", [])
except (ValueError, KeyError) as e:
    print(f"Nodes:   ✗ UNREACHABLE — could not parse kubectl output ({e})")
    raise SystemExit(20)

cp, wk = [], []
total = ok = notready = 0
for n in items:
    total += 1
    labels = n["metadata"].get("labels", {})
    conds  = {c["type"]: c["status"] for c in n.get("status", {}).get("conditions", [])}
    ready  = conds.get("Ready") == "True"
    ok += 1 if ready else 0
    notready += 0 if ready else 1
    short = n["metadata"]["name"].rsplit("-", 1)[-1]
    tag   = short if ready else f"{short}!"
    (cp if "node-role.kubernetes.io/control-plane" in labels else wk).append(tag)

if total == 0:
    print("Nodes:   ✗ UNREACHABLE — API server returned no nodes")
    raise SystemExit(20)

parts = []
if cp: parts.append("CP: " + ", ".join(cp))
if wk: parts.append("worker: " + ", ".join(wk))
print(f"Nodes:   {ok}/{total} Ready" + (f"   ({' · '.join(parts)})" if parts else ""))

if notready:
    print(f"           - {notready} node(s) NotReady")
    raise SystemExit(10)
raise SystemExit(0)
PYEOF

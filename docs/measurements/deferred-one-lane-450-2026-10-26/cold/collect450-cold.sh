#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
test "${BUSTER_9700X_HELD:-}" = 1
bash held.sh bash provenance450-cold.sh > logs/450-cold-acceptance/provenance-after.log 2>&1
tar -cf - logs/450-cold logs/450-cold-acceptance group450-cold.sh batch450-cold.sh provenance450-cold.sh accept450-cold.sh queue450-cold.sh collect450-cold.sh build450-cold.sh build450-cold-base.sh head450-cold/build/compiler base450-cold/build/compiler

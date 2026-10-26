#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
test "${BUSTER_9700X_HELD:-}" = 1
round=$1
trees=(base450-final head450-check)
if ((round % 2 == 0)); then trees=(head450-check base450-final); fi
for tree in "${trees[@]}"; do
    alias=base
    if [[ $tree == head450-check ]]; then alias=head450; fi
    # The existing benchmark pins its own lanes; preserve its 21 passes after one warmup and default 20,000 rounds.
    bash held.sh "$tree/build/compiler" benchmark-lanes --lanes 8 --cpus 2,0,1,3,4,5,6,7 --rounds 20000 > "logs/450-check/lanes-$round-$alias.log" 2>&1
done

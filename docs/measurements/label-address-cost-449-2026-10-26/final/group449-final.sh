#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
test "${BUSTER_9700X_HELD:-}" = 1
if [[ $1 == preflight ]]; then
    for unit in sqlite lstrlib lparser labels; do
        for tree in base head449-final; do
            bash held.sh bash commands449.sh "$unit" "$tree" > "logs/449-final/preflight-$unit-$tree.log" 2>&1
        done
    done
    exit 0
fi
round=$1
trees=(base head449-final)
if ((round % 2 == 0)); then trees=(head449-final base); fi
for tree in "${trees[@]}"; do
    alias=base
    if [[ $tree == head449-final ]]; then alias=head449; fi
    for mode in perf perf-labels process; do
        name=$mode
        if [[ $mode == perf-labels ]]; then name=labels-perf; fi
        bash held.sh bash commands449.sh "$mode" "$tree" > "logs/449-final/$name-$round-$alias.log" 2>&1
    done
done

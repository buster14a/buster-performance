#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_TITLE='FIFO campaign 3: #449 label-address checker cost'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/449
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/449
run()
{
    local name=$1
    shift
    "$lock" bash held.sh bash commands449.sh "$@" > "logs/449/$name.log" 2>&1
    printf '%s passed\n' "$name"
}
for tree in base head449; do
    for workload in sqlite lstrlib lparser labels; do
        run "preflight-$tree-$workload" "$workload" "$tree"
    done
done
for round in 1 2 3 4 5; do
    trees=(base head449)
    if ((round % 2 == 0)); then trees=(head449 base); fi
    for tree in "${trees[@]}"; do
        run "perf-$round-$tree" perf "$tree"
        run "labels-perf-$round-$tree" perf-labels "$tree"
        run "process-$round-$tree" process "$tree"
    done
done

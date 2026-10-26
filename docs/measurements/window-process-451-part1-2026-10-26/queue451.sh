#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_TITLE='FIFO campaign 1: #451 part 1 windows versus whole files'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/451
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/451
run()
{
    local name=$1
    shift
    "$lock" bash held.sh taskset -c 2 bash commands451.sh "$@" > "logs/451/$name.log" 2>&1
    printf '%s passed\n' "$name"
}
for workload in sqlite-e sqlite-check main-e main-parse; do
    for variant in windows whole; do
        run "preflight-$workload-$variant" preflight "$workload" "$variant"
    done
done
for round in 1 2 3 4 5; do
    for workload in sqlite-e sqlite-check main-e main-parse; do
        run "process-$round-$workload" process "$workload" "$round"
    done
    variants=(windows whole)
    if ((round % 2 == 0)); then variants=(whole windows); fi
    for workload in sqlite main; do
        for variant in "${variants[@]}"; do
            run "phase-$round-$workload-$variant" phase "$workload" "$variant"
        done
    done
done

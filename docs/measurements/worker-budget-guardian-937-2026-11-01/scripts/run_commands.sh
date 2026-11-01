#!/bin/bash
# #937: the commands' leases and wall times under a synthetic jobserver with seven spare tokens.
set -euo pipefail
root="$HOME/buster-937"
measure="$HOME/buster-937-measure"
export BUSTER_WORKER_BUDGET_TIMING=1
mkdir -p "$measure/out"
taskset -c 0-7 python3 "$measure/measure_commands.py" \
    --binary "$root/build/compiler" \
    --directory "$measure/out" \
    --sqlite "$measure/sqlite3.c" \
    --main "$measure/main.c" \
    --helper "$measure/helper.c" \
    --runs "${RUNS:-15}" \
    --tokens 7 --jobs 8

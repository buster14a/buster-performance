#!/bin/bash
# #937: real GNU make -j8 confirmation of the lease count and wall time.
set -euo pipefail
measure="$HOME/buster-937-measure"
export BUSTER_WORKER_BUDGET_TIMING=1
mkdir -p "$measure/out"
taskset -c 0-7 python3 "$measure/run_make.py" \
    --makefile "$measure/Makefile" \
    --directory "$measure" \
    --runs "${RUNS:-5}" \
    --jobs 8

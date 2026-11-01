#!/bin/bash
# #937: one lease's acquire and release costs on the 9700X, outside a compiler command.
set -euo pipefail
root="$HOME/buster-937"
measure="$HOME/buster-937-measure"
export BUSTER_WORKER_BUDGET_TIMING=1
for tokens in 1 2 7; do
    echo "== tokens=$tokens"
    taskset -c 2 "$measure/lease_cost" "$root/build/compiler" "$tokens" 51
done

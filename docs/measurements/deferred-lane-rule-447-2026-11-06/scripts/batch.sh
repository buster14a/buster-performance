#!/bin/bash
# batch.sh LOG ROUND CONFIGS UNIT...: inside one lock hold (queue.sh's), bench.sh on each unit in turn with CONFIGS
# (comma-separated), the units' and the configurations' orders rotating by round.
set -u
D=~/buster-fast-bench/447-claude
log=$1
round=$2
IFS=, read -r -a configs <<< "$3"
shift 3
units=("$@")
n=${#units[@]}
c=${#configs[@]}
for ((i = 0; i < n; i++)); do
    unit=${units[$(((i + round - 1) % n))]}
    ordered=()
    for ((j = 0; j < c; j++)); do
        ordered+=("${configs[$(((j + round + i - 1) % c))]}")
    done
    "$D/scripts/bench.sh" "$log" "$round" "$unit" "${ordered[@]}"
done

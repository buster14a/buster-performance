#!/bin/bash
# queue.sh NAME ROUNDS CONFIGS GROUP...: for each round, each GROUP (a space-separated list of units, one argument) in
# an order that rotates by round, one lock hold (exclusive.sh) running batch.sh on the group's units with CONFIGS
# (comma-separated). The groups are sized so that a hold lasts under a minute. Appends to logs/NAME.log;
# logs/NAME.queue gives each hold's start, end and status, and `done` at the end (unless NO_DONE is set). FIRST_ROUND
# (1 by default) starts at a later round, for a queue continued with its groups merged into fewer holds.
set -u
D=~/buster-fast-bench/447-claude
name=$1
rounds=$2
configs=$3
shift 3
groups=("$@")
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 deferred lane-count acceptance" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
mkdir -p "$D/logs"
log="$D/logs/$name.log"
for ((round = ${FIRST_ROUND:-1}; round <= rounds; round++)); do
    n=${#groups[@]}
    for ((i = 0; i < n; i++)); do
        group=${groups[$(((i + round - 1) % n))]}
        read -r -a units <<< "$group"
        begin=$(date -Is)
        ~/buster-fast-bench/exclusive.sh "$D/scripts/batch.sh" "$log" "$round" "$configs" "${units[@]}"
        echo "$begin $(date -Is) status=$? round=$round units=${units[*]}" >> "$D/logs/$name.queue"
    done
done
if [ -z "${NO_DONE:-}" ]; then
    echo "done $(date -Is)" >> "$D/logs/$name.queue"
fi

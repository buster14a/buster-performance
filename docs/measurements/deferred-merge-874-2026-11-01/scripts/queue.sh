#!/bin/bash
# Rounds FIRST_ROUND..ROUNDS of JOBS, a lock hold per batch of BATCH jobs, PAUSE seconds apart. Arguments: JOBS LOG FIRST_ROUND FIRST_JOB ROUNDS BATCH PAUSE.
. ~/buster-fast-bench/874-verify/scripts/env.sh
jobs="$D/$1"
L="$D/$2"
first_round="$3"
first_job="$4"
rounds="$5"
batch="$6"
pause="$7"
total=$(wc -l < "$jobs")
for ((round = first_round; round <= rounds; round += 1)); do
    start=0
    if [ "$round" = "$first_round" ]; then
        start="$first_job"
    fi
    for ((first = start; first < total; first += batch)); do
        ~/buster-fast-bench/exclusive.sh "$D/scripts/batch.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/logs/queue.lock.txt"
        sleep "$pause"
    done
done
echo "done $(date -Is)" >> "$L"

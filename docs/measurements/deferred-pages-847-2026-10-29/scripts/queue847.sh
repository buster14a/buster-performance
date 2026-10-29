#!/bin/bash
# #847: queue.sh with batch847.sh. Rounds FIRST_ROUND to ROUNDS of the jobs in JOBS, the first round from job FIRST_JOB, a lock hold per batch of BATCH
# jobs (batch.sh), PAUSE seconds apart, into LOG; the lock's waiting messages into logs/queue.lock.txt. Arguments:
# JOBS LOG FIRST_ROUND FIRST_JOB ROUNDS BATCH PAUSE. Record A2's queue-resume.sh with this work directory.
. ~/buster-fast-bench/claude-764/scripts/env.sh
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
        ~/buster-fast-bench/exclusive.sh "$D/scripts/batch847.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/logs/queue.lock.txt"
        sleep "$pause"
    done
done
echo "done $(date -Is)" >> "$L"

#!/bin/bash
# Rounds FIRST_ROUND to ROUNDS of the jobs in JOBS, the first round from job FIRST_JOB, a lock hold per batch of BATCH
# jobs (3-batch.sh), PAUSE seconds apart, into LOG. Arguments: JOBS LOG FIRST_ROUND FIRST_JOB ROUNDS BATCH PAUSE.
# Record A2's queue-resume.sh with this work directory.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 2's lane costs and rule on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
jobs="$D/$1"
L="$D/$2"
first_round="$3"
first_job="$4"
rounds="$5"
batch="$6"
pause="$7"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
total=$(wc -l < "$jobs")
for ((round = first_round; round <= rounds; round += 1)); do
    start=0
    if [ "$round" = "$first_round" ]; then
        start="$first_job"
    fi
    for ((first = start; first < total; first += batch)); do
        ~/buster-fast-bench/exclusive.sh "$D/3-batch.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/3-queue.lock.txt"
        sleep "$pause"
    done
done
echo done >> "$L"

#!/bin/bash
# queue.sh from a given place: rounds FIRST_ROUND to ROUNDS of the jobs in JOBS, the first round from job FIRST_JOB, a
# lock hold per batch of BATCH jobs (batch.sh), PAUSE seconds apart, into LOG.
# Arguments: JOBS LOG FIRST_ROUND FIRST_JOB ROUNDS BATCH PAUSE.
D=/home/david/buster-fast-bench/113-lanes-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): the merged tree against main on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6466271358"
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
        ~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/queue.lock.txt"
        sleep "$pause"
    done
done
echo done >> "$L"

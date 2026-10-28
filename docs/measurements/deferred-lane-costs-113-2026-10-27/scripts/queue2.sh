#!/bin/bash
# #113's lane costs: rounds FIRST to ROUNDS of the jobs in JOBS, a lock hold per batch of BATCH jobs (batch.sh), PAUSE
# seconds apart, into LOG. Writes its PID to queue2.pid. Arguments: JOBS LOG ROUNDS BATCH PAUSE FIRST.
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/queue2.pid"
export EXCLUSIVE_OWNER=claude-113-lanes
export EXCLUSIVE_TITLE="#113 deferred reader lane costs: first lane, kept arenas, lane rule (9700X, before and after)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6448574179"
jobs="$D/$1"
L="$D/$2"
rounds="$3"
batch="$4"
pause="$5"
first_round="$6"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
total=$(wc -l < "$jobs")
for ((round = first_round; round <= rounds; round += 1)); do
    for ((first = 0; first < total; first += batch)); do
        ~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/queue.lock.txt"
        sleep "$pause"
    done
done
echo done >> "$L"

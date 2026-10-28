#!/bin/bash
# #113's lane costs: ROUNDS rounds of the jobs in JOBS, a lock hold per batch of BATCH jobs (batch.sh), PAUSE seconds
# apart, into LOG. Writes its PID to queue.pid (setsid makes it a session of its own: kill -- -PID stops it all).
# Arguments: JOBS LOG ROUNDS BATCH PAUSE.
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/queue.pid"
export EXCLUSIVE_OWNER=claude-113-lanes
export EXCLUSIVE_TITLE="#113 deferred reader lane costs: first lane, kept arenas, lane rule (9700X grid)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6448574179"
jobs="$D/$1"
L="$D/$2"
rounds="$3"
batch="$4"
pause="$5"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
total=$(wc -l < "$jobs")
for ((round = 1; round <= rounds; round += 1)); do
    for ((first = 0; first < total; first += batch)); do
        ~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$L" "$round" "$jobs" "$first" "$batch" > /dev/null 2>> "$D/queue.lock.txt"
        sleep "$pause"
    done
done
echo done >> "$L"

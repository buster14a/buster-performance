#!/bin/bash
# Campaign B's rest, in three lock holds against a busy lock: round 2's jobs after its first batch (jobs 15 to 42 of its
# order), round 3's 43 jobs, then c-testsuite's 220 programs by the branch's rule alone (logCT.txt).
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/chainB3.pid"
export EXCLUSIVE_OWNER=claude-113-lanes
export EXCLUSIVE_TITLE="#113 deferred reader lane costs: before and after on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6448574179"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$D/logB.txt" 2 "$D/jobsB.txt" 15 28 > /dev/null 2>> "$D/queue.lock.txt"
sleep 40
~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$D/logB.txt" 3 "$D/jobsB.txt" 0 43 > /dev/null 2>> "$D/queue.lock.txt"
echo done >> "$D/logB.txt"
sleep 40
mapfile -t programs < <(grep -v '^#' "$D/final/tests/c-testsuite/subset.txt" | grep -v '^$')
: > "$D/logCT.txt"
~/buster-fast-bench/exclusive.sh "$D/batchCT2.sh" "$D/logCT.txt" "${programs[@]}" > /dev/null 2>> "$D/queue.lock.txt"
echo done >> "$D/logCT.txt"

#!/bin/bash
# The cloud session confirmation campaigns on the merged tree (branch) against current main, after the builds:
# A, the every-lane grid (3 rounds, 6 jobs a lock hold); B, eight lanes against one by each tree rule (5 rounds, a
# round a hold); CT, c-testsuite 220 programs by both rules (3 rounds, a round a hold); 30 s between holds.
D=~/buster-fast-bench/113-lanes-cloud
cd "$D" || exit 1
echo $$ > "$D/chain.pid"
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): the merged tree against main on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6466271358"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
"$D/queue.sh" jobsA.txt logA.txt 3 6 30
"$D/queue.sh" jobsB.txt logB.txt 5 43 30
mapfile -t programs < <(grep -v "^#" "$D/branch/tests/c-testsuite/subset.txt" | grep -v "^$")
: > "$D/logCT.txt"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/batchCT.sh" "$D/logCT.txt" "$round" "${programs[@]}" > /dev/null 2>> "$D/queue.lock.txt"
    sleep 30
done
echo done >> "$D/logCT.txt"

#!/bin/bash
# The confirmation campaigns reordered (master.sh stopped A after 234 runs of its first round, jobs 0 to 29): B (5
# rounds, a round a hold) and CT (3 rounds, a round a hold) first, then the rest of A (round 1 from job 30, then rounds 2
# and 3, 11 jobs a hold), then the mutants; 30 s between holds.
D=/home/david/buster-fast-bench/113-lanes-cloud
cd "$D" || exit 1
echo $$ > "$D/master2.pid"
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): the merged tree against main on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6466271358"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
"$D/queue-resume.sh" jobsB.txt logB.txt 1 0 5 43 30
mapfile -t programs < <(grep -v "^#" "$D/branch/tests/c-testsuite/subset.txt" | grep -v "^$")
: > "$D/logCT.txt"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/batchCT.sh" "$D/logCT.txt" "$round" "${programs[@]}" > /dev/null 2>> "$D/queue.lock.txt"
    sleep 30
done
echo done >> "$D/logCT.txt"
"$D/queue-resume.sh" jobsA.txt logA.txt 1 30 3 11 30
"$D/mutants/chain.sh" 120
echo "master2 done $(date -Is)" >> "$D/master.txt"

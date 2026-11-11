#!/bin/bash
# #2086 on the 9700X: test-parser without files by base (main 28653e0f5) and clear (this branch with #2087's clearing
# put back), whose difference is the reused scratch check's cost and the fix's. As measure.sh: one hold of the lock per
# run, time-runs' one warm-up and one timed run, pinned to CPU 2, the order alternating from round to round.
set -u
D=~/buster-fast-bench/2086-claude
export EXCLUSIVE_OWNER=claude-2086-k5 EXCLUSIVE_TITLE="Parser K5 stale scratch (#2086)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2086
until grep -q 'more done' $D/more.log; do sleep 10; done
cd $D/final || exit 1
rounds=${ROUNDS:-3}
for round in $(seq 1 $rounds); do
    order="base clear"
    [ $((round % 2)) = 0 ] && order="clear base"
    for build in $order; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/bin/reuse time-runs --runs 1 --warmups 1 --build $build $D/bin/$build --list test-parser > $D/results/plain2-$build-$round.txt 2>&1
        echo "$round plain $build: $(grep -E '^run 1 list 1:' $D/results/plain2-$build-$round.txt)"
    done
done
echo "== done $(date -u +%FT%TZ)"

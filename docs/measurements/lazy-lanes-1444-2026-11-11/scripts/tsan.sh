#!/bin/sh
# #1444: a ThreadSanitizer build of the head (a copy of its tree), and its test-lanes and test-check-lanes, each one hold.
#   tsan.sh
d=~/buster-fast-bench/1444-claude-lanes
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
[ -d $d/tree-head-tsan ] || (cd $d/repo && git worktree add -q --detach $d/tree-head-tsan 0aed4cb134c1fd92bd1a67f960eebb29a6cf0dc3)
cd $d/tree-head-tsan
: > $d/results/tsan-head.status
(BUSTER_SANITIZER=thread BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh) > $d/results/tsan-head-build.log 2>&1
echo "build: status $?" >> $d/results/tsan-head.status
for t in test-lanes test-check-lanes; do
    ~/buster-fast-bench/exclusive.sh ./build/compiler $t > $d/results/tsan-head-$t.log 2>&1
    echo "$t: status $?" >> $d/results/tsan-head.status
done
echo done >> $d/results/tsan-head.status

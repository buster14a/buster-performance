#!/bin/sh
# #1444: the head's tests on the 9700X, its own Release build (the shifts' build tree), each one hold of the lock.
#   tests.sh
d=~/buster-fast-bench/1444-claude-lanes
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
cd $d/tree-head
C=$d/tree-head/build/compiler
: > $d/results/tests-head.status
for t in test-lanes test-check-lanes test-check-units test-checker-deferred test-call-graph; do
    ~/buster-fast-bench/exclusive.sh $C $t > $d/results/test-head-$t.log 2>&1
    echo "$t: status $?" >> $d/results/tests-head.status
done
(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh check-call-graph) > $d/results/test-head-check-call-graph.log 2>&1
echo "check-call-graph: status $?" >> $d/results/tests-head.status
echo done >> $d/results/tests-head.status

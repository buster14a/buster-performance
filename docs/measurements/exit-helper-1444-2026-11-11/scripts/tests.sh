#!/bin/sh
# #1444's exit helper: the head's tests on the 9700X, its Release build (tree-head/build/compiler), each one hold;
# test-checker-driver in eight parts each way; then a ThreadSanitizer build's test-lanes (a copy of the head's tree).
#   tests.sh
. ~/buster-fast-bench/1444-claude-exit/env.sh
cd $d/tree-head
C=$d/tree-head/build/compiler
: > $d/results/tests-head.status
run()
{
    name=$1
    shift
    ~/buster-fast-bench/exclusive.sh "$@" > $d/results/test-head-$name.log 2>&1
    echo "$name: status $?, zombies $(ps -eo stat | grep -c '^Z')" >> $d/results/tests-head.status
}
run test-lanes $C test-lanes
run test-check-lanes $C test-check-lanes
run test-check-units $C test-check-units
run test-parallel $C test-parallel
for part in 1 2 3 4 5 6 7 8; do
    run test-checker-driver-executable-$part $C test-checker-driver --executable $C --part $part/8
    run test-checker-driver-in-process-$part $C test-checker-driver --executable $C --in-process --part $part/8
done
[ -d $d/tree-head-tsan ] || (cd $d/repo && git worktree add -q --detach $d/tree-head-tsan 88bce28e94969107ef5b3e3671b5b2d1cedb4d65)
cd $d/tree-head-tsan
(BUSTER_SANITIZER=thread BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh) > $d/results/tsan-head-build.log 2>&1
echo "tsan build: status $?" >> $d/results/tests-head.status
run tsan-test-lanes $d/tree-head-tsan/build/compiler test-lanes
echo done >> $d/results/tests-head.status

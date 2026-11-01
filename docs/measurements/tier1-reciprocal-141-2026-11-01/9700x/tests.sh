#!/usr/bin/env bash
# tests.sh TREE: Tier 1's tests, c-testsuite's subset by --tier1, the call graph check and the compiler's own main.c
# (-fsyntax-only, -c --verify, --tier1 -c) on TREE's build, each one hold of the shared lock; logs in logs-tests-TREE/.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
tree=$PWD/$1
logs=$PWD/logs-tests-$1
mkdir -p $logs
test1() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $tree && $* > $logs/$n.log 2>&1; echo \"exit \$?\" >> $logs/$n.log"
    echo "$n $(tail -1 $logs/$n.log): $(tail -2 $logs/$n.log | head -1 | cut -c1-160)"
}
SELF="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing"
test1 select ./build/compiler test-tier1-select
test1 liveness ./build/compiler test-tier1-liveness
test1 emit ./build/compiler test-tier1-emit
test1 pipeline ./build/compiler test-tier1-pipeline --cross-check
test1 cfg ./build/compiler test-tier1-cfg
test1 frame-execution ./build/compiler test-tier1-frame-execution
test1 allocation ./build/compiler test-tier1-allocation
test1 schedule ./build/compiler test-tier1-schedule
test1 model ./build/compiler test-tier1-model
test1 c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
test1 call-graph ./build.sh check-call-graph
test1 self ./build/compiler -fsyntax-only $SELF -Wall -Werror src/buster/compiler/main.c
test1 self-c ./build/compiler -c --verify $SELF -o $RUNDIR/self-$1.o src/buster/compiler/main.c
test1 self-t1 ./build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -c $SELF -o $RUNDIR/self-t1-$1.o src/buster/compiler/main.c
echo done > $logs/done

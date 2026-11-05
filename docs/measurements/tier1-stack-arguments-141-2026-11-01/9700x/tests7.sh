#!/usr/bin/env bash
# tests7.sh TREE: the union of tests5.sh's and tests6.sh's suites, for a tree that holds both the narrow arguments' IR
# lowering and Tier 1's stack arguments and floating values: the IR's, SSA's and the interpreters' (on real C too), Tier
# 1's, the frame's, the driver's, the unwind tables', c-testsuite's subset by --tier1 and by --cross-check, and the call
# graph, each one hold of the shared lock, logs in TREE-tests/.
. ~/buster-fast-bench/claude-141-remaining/common.sh
t=$1
out=$PWD/$t-tests
mkdir -p $out
run() {
    local name=$1
    shift
    "$lock" bash -c "cd $t && $* > $out/$name.log 2>&1; echo \"exit \$?\" >> $out/$name.log"
    echo "$name: $(grep -E 'checks|tests:|totals|exit' $out/$name.log | tail -2 | tr '\n' ' ')"
}
files=$(sed -n "s|^\([0-9][0-9]*\)$|$CTS/tests/single-exec/\1.c|p" $t/tests/c-testsuite/subset.txt | tr '\n' ' ')
run ir ./build/compiler test-ir
run ir-lowering ./build/compiler test-ir-lowering
run ir-interpreter ./build/compiler test-ir-interpreter
run interpreter ./build/compiler test-interpreter
run ir-inline ./build/compiler test-ir-inline
run ir-optimize ./build/compiler test-ir-optimize
run ssa-ir ./build/compiler test-ssa-ir
run ir-source ./build/compiler test-ir-source $files
run ir-source-sqlite ./build/compiler test-ir-source $FLAGS -I$Q $Q/sqlite3.c
run ssa-source ./build/compiler test-ssa-source $files
run ssa-source-generated ./build/compiler test-ssa-source --generate 48
run select ./build/compiler test-tier1-select
run emit ./build/compiler test-tier1-emit
run pipeline ./build/compiler test-tier1-pipeline --cross-check
run cfg ./build/compiler test-tier1-cfg
run liveness ./build/compiler test-tier1-liveness
run masks ./build/compiler test-tier1-masks
run frame ./build/compiler test-tier1-frame
run frame-execution ./build/compiler test-tier1-frame-execution
run check-debug ./build/compiler test-check-debug --cross-check
run checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
run c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
run c-testsuite-cross ./build/compiler test-c-testsuite --cross-check --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
run call-graph ./build.sh check-call-graph
echo done > $out/done

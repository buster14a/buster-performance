#!/usr/bin/env bash
# tests6.sh TREE: the suites #141's stack arguments and parameters touch, each one hold of the shared lock, logs in
# TREE-tests/: Tier 1's, the frame's, the driver's (whose stack fixture links clang -O2's code), the unwind tables' of
# Tier 1's frames (test-check-debug), c-testsuite's subset by --tier1 and the call graph.
. ~/buster-fast-bench/claude-141-remaining/common.sh
t=$1
out=$PWD/$t-tests
mkdir -p $out
run() {
    local name=$1
    shift
    "$lock" bash -c "cd $t && $* > $out/$name.log 2>&1; echo \"exit \$?\" >> $out/$name.log"
    echo "$name: $(grep -E 'checks|tests:|exit' $out/$name.log | tail -2 | tr '\n' ' ')"
}
run select ./build/compiler test-tier1-select
run emit ./build/compiler test-tier1-emit
run pipeline ./build/compiler test-tier1-pipeline --cross-check
run cfg ./build/compiler test-tier1-cfg
run liveness ./build/compiler test-tier1-liveness
run frame ./build/compiler test-tier1-frame
run frame-execution ./build/compiler test-tier1-frame-execution
run check-debug ./build/compiler test-check-debug --cross-check
run checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
run c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
run c-testsuite-cross ./build/compiler test-c-testsuite --cross-check --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
run call-graph ./build.sh check-call-graph
echo done > $out/done

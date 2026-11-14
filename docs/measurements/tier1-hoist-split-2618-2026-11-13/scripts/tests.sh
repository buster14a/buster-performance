#!/usr/bin/env bash
# run.sh COMPILER OUT: the Tier 1 and IR tests of tools/ci/correctness.tests that this change reaches, each one's tail.
B=$1; O=$2; cd /home/user/buster
SUB=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
: > $O
t() { local name="$*"; local log=$(mktemp); timeout 3000 "$@" > $log 2>&1; local rc=$?; echo "== rc=$rc: ${name:0:160}" >> $O; tail -3 $log >> $O; rm -f $log; }
t $B test-tier1-emit
t $B test-tier1-pipeline --cross-check
t $B test-tier1-allocation
t $B test-tier1-cfg
t $B test-tier1-frame
t $B test-tier1-frame-execution
t $B test-tier1-masks
t $B test-tier1-wide
t $B test-tier1-model
t $B test-tier1-schedule
t $B test-tier1-liveness
t $B test-emission-metadata
t $B test-emitted-code --cross-check
t $B test-ir
t $B test-tier0 --cross-check
t $B test-tier1-cfg-source $SUB
t $B test-tier1-cfg-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
t $B test-c-testsuite --tier1 --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
t $B test-ssa-source --typed --tier1 $SUB
t $B test-ssa-source --typed --tier1 --self-test
t $B test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
t $B test-ssa-source --typed --tier1 --generate 48 --clang clang
echo done >> $O

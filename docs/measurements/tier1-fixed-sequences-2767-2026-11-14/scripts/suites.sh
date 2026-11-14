#!/usr/bin/env bash
# suites.sh: the Tier 1 suites #2766 ran, on build/compiler (Develop, native), each's exit status and seconds.
cd /home/user/buster
B=./build/compiler
L=$HOME/.cache/claude-2767/suites; mkdir -p $L
run() { name=$1; shift; s=$(date +%s); "$@" > $L/$name.log 2>&1; rc=$?; echo "$name exit $rc $(( $(date +%s) - s ))s"; }
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
run tier1-pipeline $B test-tier1-pipeline --cross-check
for t in emit schedule select liveness cfg allocation frame frame-execution masks wide model; do run tier1-$t $B test-tier1-$t; done
run emission-metadata $B test-emission-metadata
run emitted-code $B test-emitted-code --cross-check
run ir $B test-ir
run ir-lowering $B test-ir-lowering
run ir-optimize $B test-ir-optimize
run tier0 $B test-tier0 --cross-check
run tier1-cfg-source $B test-tier1-cfg-source $subset
run c-testsuite-tier1 $B test-c-testsuite --tier1 --code-size --clang clang --jobs 2 --subset tests/c-testsuite/subset.txt build/c-testsuite
run ssa-self $B test-ssa-source --typed --tier1 --self-test
run ssa-generate $B test-ssa-source --typed --tier1 --generate 48 --clang clang
run ssa-lifetimes $B test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run ssa-subset $B test-ssa-source --typed --tier1 $subset
run ssa-interpreter $B test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
for d in tier1_truth tier1_patterns tier1_sparse_switch tier1_symbols; do
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/$d.c -o build/test-driver-$d && run driver-$d ./build/test-driver-$d $B "$(command -v clang)"
done
echo done

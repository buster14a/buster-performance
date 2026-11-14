#!/usr/bin/env bash
# tests.sh LOG: the Tier 1 correctness commands, each logged with its status.
cd /home/user/buster
log=$1; : > $log
B=./build/compiler
run() { local start=$(date +%s); "$@" > $log.$(echo "$*" | md5sum | cut -c1-8) 2>&1; local rc=$?; echo "rc=$rc $(( $(date +%s) - start ))s :: $*" >> $log; }
run $B test-tier1-pipeline --cross-check
run $B test-tier1-emit
run $B test-tier1-schedule
run $B test-tier1-select
run $B test-tier1-liveness
run $B test-tier1-cfg
run $B test-tier1-allocation
run $B test-ssa-source --typed --tier1 --self-test
run $B test-ssa-source --typed --tier1 --generate 48 --clang clang
run $B test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run $B test-c-testsuite --tier1 --code-size --clang clang --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
run $B test-ssa-source --typed --tier1 $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
run $B test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
for t in truth patterns sparse_switch symbols; do
  clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/tier1_$t.c -o build/test-driver-tier1-$t && run ./build/test-driver-tier1-$t $B "$(command -v clang)"
done
echo done >> $log

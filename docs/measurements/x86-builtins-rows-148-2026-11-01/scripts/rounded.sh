#!/bin/bash
# #148's AVX-512 rounded arithmetic: the head built, its tests, then base (447e1bd) against head, each in a hold of the lock.
set -u
B=~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: AVX-512 arithmetic by a rounding control" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1010
X=~/buster-fast-bench/exclusive.sh
L=$B/rounded-logs; mkdir -p $L; : > $L/status
cd $B/t002332f
$X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $? $(tail -1 build.log)" >> $L/status
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for t in "test-checker --program-vectors" "test-check-builtins-x86" "test-builtin-intrinsic-catalog" "test-x86-semantics --cross-check" "test-tier0 --cross-check" "test-x86-intrinsics" "test-checker --seed 133" "test-check-builtins" "test-preprocessor --clang" "test-checker-driver --executable ./build/compiler"; do
  n=$(echo $t | tr " /." "___")
  $X ./build/compiler $t > $L/$n.log 2>&1; echo "$t $? $(tail -1 $L/$n.log)" >> $L/status
done
$X taskset -c 0-7 ./build.sh check-call-graph > $L/callgraph.log 2>&1; echo "call-graph $? $(tail -1 $L/callgraph.log)" >> $L/status
cd ~/buster-fast-bench/rounded-148
$X ./measure.sh base head > measure.log 2> measure.stderr; echo "measure $?" >> $L/status
echo done >> $L/status

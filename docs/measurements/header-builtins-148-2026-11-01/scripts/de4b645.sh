#!/bin/bash
# #148's header builtins: base (b823d1c) and head built, the head's tests, then base against head, each in a hold of the lock.
set -u
B=~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: x86 header builtins" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
X=~/buster-fast-bench/exclusive.sh
L=$B/header-logs2; mkdir -p $L; : > $L/status
for t in tde4b645; do (cd $B/$t && $X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $t $? $(tail -1 build.log)" >> $L/status); done
cd $B/tde4b645
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for t in "test-checker --program-vectors" "test-builtin-intrinsic-catalog" "test-check-builtins" "test-checker --seed 133" "test-checker-deferred" "test-checker-driver --executable ./build/compiler" "test-preprocessor --clang" "test-x86-semantics --cross-check"; do
  n=$(echo $t | tr " /." "___")
  $X ./build/compiler $t > $L/$n.log 2>&1; echo "$t $? $(tail -1 $L/$n.log)" >> $L/status
done
$X taskset -c 0-7 ./build.sh check-call-graph > $L/callgraph.log 2>&1; echo "call-graph $? $(tail -1 $L/callgraph.log)" >> $L/status
cd ~/buster-fast-bench/header-148
$X ./measure.sh base head > measure.log 2> measure.stderr; echo "measure $?" >> $L/status
echo done >> $L/status

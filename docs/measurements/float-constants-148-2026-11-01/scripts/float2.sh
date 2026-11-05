#!/bin/bash
set -u
B=~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: signaling NaNs and _Float16/__float128 constants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
X=~/buster-fast-bench/exclusive.sh
L=$B/float-logs2; mkdir -p $L; : > $L/status
cd $B/t447e1bd
$X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $? $(tail -1 build.log)" >> $L/status
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for t in "test-checker-driver --executable ./build/compiler" "test-preprocessor --clang" "test-checker --program-library" "test-checker --program-float-constants"; do
  n=$(echo $t | tr " /." "___")
  $X ./build/compiler $t > $L/$n.log 2>&1; echo "$t $? $(tail -1 $L/$n.log)" >> $L/status
done
echo done >> $L/status

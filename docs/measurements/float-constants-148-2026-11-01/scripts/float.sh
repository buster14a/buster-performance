#!/bin/bash
# The float constants slice (#148): base and head built, head's tests, then base against head, each in a hold of the lock.
set -u
B=~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: signaling NaNs and _Float16/__float128 constants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
X=~/buster-fast-bench/exclusive.sh
L=$B/float-logs; mkdir -p $L; : > $L/status
echo 1cd79711a1fe2526c70f3f331b4aa8f1e8e599a8 > $B/t1cd7971/COMMIT
echo d57d51537351d320b5ed22bf8b46c63872a25f21 > $B/td57d515/COMMIT
for t in t1cd7971 td57d515; do (cd $B/$t && $X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $t $? $(tail -1 build.log)" >> $L/status); done
cd $B/td57d515
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for t in "test-checker --program-float-constants" "test-check-builtins-float" "test-checker --seed 133" "test-check-builtins" "test-builtin-lowering" "test-checker-deferred" "test-checker-driver --executable ./build/compiler" "test-preprocessor --clang"; do
  n=$(echo $t | tr ' /.' '___')
  $X ./build/compiler $t > $L/$n.log 2>&1; echo "$t $? $(tail -1 $L/$n.log)" >> $L/status
done
$X taskset -c 0-7 ./build.sh check-call-graph > $L/callgraph.log 2>&1; echo "call-graph $? $(tail -1 $L/callgraph.log)" >> $L/status
cd ~/buster-fast-bench/float-148
$X ./measure.sh base head > measure.log 2> measure.stderr; echo "measure $?" >> $L/status
echo done >> $L/status

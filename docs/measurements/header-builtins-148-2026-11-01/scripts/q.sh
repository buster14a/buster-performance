#!/bin/bash
cd ~/buster-fast-bench/header-148
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: x86 header builtins (qualify f482e51)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1040
X=~/buster-fast-bench/exclusive.sh
L=$PWD/q-logs; rm -rf $L; mkdir $L
cd tf482e51 && $X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $? $(tail -1 build.log)" >> $L/status
for t in "test-checker --program-vectors" "test-builtin-intrinsic-catalog" "test-check-builtins" "test-checker --seed 133" "test-checker-deferred" "test-checker-driver --executable ./build/compiler" "test-x86-semantics --cross-check"; do $X taskset -c 0-7 ./build/compiler $t > $L/${t%% *}-$(echo $t | tr -c a-z0-9 _ | cut -c1-40).log 2>&1; s=$?; echo "$t $s $(tail -1 $L/${t%% *}-$(echo $t | tr -c a-z0-9 _ | cut -c1-40).log)" >> $L/status; done
$X taskset -c 0-7 ./build.sh check-call-graph > $L/cg.log 2>&1; echo "call-graph $? $(tail -1 $L/cg.log)" >> $L/status
cd ..; rm -f measure-sqlite.log measure-stb.log
$X ./measure.sh tb823d1c tf482e51 > measure.log 2> measure.stderr; echo "measure $?" >> $L/status
echo done >> $L/status

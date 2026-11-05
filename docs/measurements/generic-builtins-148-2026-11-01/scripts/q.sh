#!/bin/bash
cd ~/buster-fast-bench/generic-148
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: generic builtins (qualify 0bb0d71)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1040
X=~/buster-fast-bench/exclusive.sh
L=$PWD/q-logs; rm -rf $L; mkdir $L
cd t0bb0d71 && $X env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "build $? $(tail -1 build.log)" >> $L/status
n=0
for t in "test-checker --program-align" "test-check-builtins-misc" "test-builtin-intrinsic-catalog" "test-check-builtins" "test-checker --program-vectors" "test-checker --seed 133" "test-checker-deferred" "test-checker-driver --executable ./build/compiler" "test-preprocessor --clang" "test-x86-semantics --cross-check"; do n=$((n+1)); $X taskset -c 0-7 ./build/compiler $t > $L/t$n.log 2>&1; s=$?; echo "$t $s $(tail -1 $L/t$n.log)" >> $L/status; done
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
$X ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > $L/self.log 2>&1; echo "self-check $? $(tail -1 $L/self.log)" >> $L/status
$X taskset -c 0-7 ./build.sh check-call-graph > $L/cg.log 2>&1; echo "call-graph $? $(tail -1 $L/cg.log)" >> $L/status
cd ..; rm -f measure-sqlite.log measure-stb.log
$X ./measure.sh tf482e51 t0bb0d71 > measure.log 2> measure.stderr; echo "measure $?" >> $L/status
echo done >> $L/status

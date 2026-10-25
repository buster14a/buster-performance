#!/bin/bash
# #395's decoder and relocation kernels (e2555ea) against the merged tree (a29db0f) on the 9700X: each step its own lock.
base=~/buster-fast-bench/claude-linker-80
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/395
L=~/buster-fast-bench/exclusive.sh
log=$base/logs395m; mkdir -p $log
echo "start $(date -Is)" > $log/status
cd $base/tree395m || exit 1
EXCLUSIVE_TITLE="395 DWARF: build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
sha256sum build/compiler $base/tree395/build/compiler > $log/compiler.sha256
s=$base/inputs/sqlite-amalgamation-3530400; w=$base/dwarf395; mkdir -p $w
EXCLUSIVE_TITLE="395 DWARF: compile SQLite with -g" $L bash -c "cd $w && gcc -O2 -g -c $s/sqlite3.c -o sqlite3.o & gcc -O2 -g -c $s/shell.c -I$s -o $w/shell.o & gcc -O2 -g -gz=none -c $s/sqlite3.c -o $w/sqlite3_u.o & gcc -O2 -g -gz=none -c $s/shell.c -I$s -o $w/shell_u.o & wait" > $log/compile.log 2>&1; echo "compile=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="395 DWARF: tests" $L bash -c "./build/compiler test-inflate && ./build/compiler test-foreign --cross-check" > $log/tests.log 2>&1; echo "tests=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="395 DWARF: links of SQLite -g, CPU 2" $L $base/measure395.sh $base/tree395/build/compiler $base/tree395m/build/compiler $w > $log/measure.log 2>&1; echo "measure=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status

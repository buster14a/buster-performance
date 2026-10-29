#!/bin/bash
# #152's final round on the 9700X: the head's and main's builds, the units' tests, the scaling (measure.sh), and the
# one-file commands of main against the head. Each step is one hold of the lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/final.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (final round)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh "$@"; }
for t in final main2; do (cd $E/tree-$t && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1); done
H=$E/tree-final/build/compiler
M=$E/tree-main2/build/compiler
echo "== tests"
cd $E/tree-final && lock bash -c "timeout 400 ./build/compiler test-check-units 2>&1 | tail -8; timeout 300 ./build/compiler test-check-units --corpus $W/inputs/c-testsuite/tests/single-exec 2>&1 | tail -3"
RUNS=5 $W/measure.sh $H $W/final lua synth musl
echo "== one file: main and the head"
SQ=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
CT=$W/inputs/c-testsuite/tests/single-exec/00220.c
mkdir -p $W/final/one && cd $W/final/one && cp $W/floor/tiny.c .
lock $H time-runs --executable /bin/sh --runs 15 \
    --list -c "taskset -c 2 $M -c -o main.o $SQ" \
    --list -c "taskset -c 2 $H -c -o head.o $SQ" \
    --list -c "taskset -c 2 $H -c $SQ tiny.c" \
    --list -c "taskset -c 0-7 $M -c -o main8.o $SQ" \
    --list -c "taskset -c 0-7 $H -c -o head8.o $SQ" \
    --list -c "taskset -c 2 $M -fsyntax-only $SQ" \
    --list -c "taskset -c 2 $H -fsyntax-only $SQ" \
    --list -c "taskset -c 2 $M -o main_exe $CT" \
    --list -c "taskset -c 2 $H -o head_exe $CT" | grep -v "^run "
cmp main.o head.o && cmp main8.o head8.o && echo "objects: main's and the head's the same bytes"
echo finished

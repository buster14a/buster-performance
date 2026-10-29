#!/bin/bash
export CORES_TITLE="solve #152 multi-file driver (arena pool with eviction)" CORES_LINK="https://github.com/buster14a/buster/issues/152"
L=~/.cache/claude-152/localp2
mkdir -p $L/tmp
export TMPDIR=$L/tmp
for v in p1 p2; do
    T=~/.cache/claude-152/tree-$v
    (cd $T && nice -n 19 cores -n 4 -- ./build.sh > $L/build-$v.log 2>&1; echo "build exit=$?" >> $L/build-$v.log)
done
cores -n 8 -- bash -c '
cd ~/.cache/claude-152/many
for v in 8 p1 p2; do rm -f ./*.o; strace -f -c -o '$L'/strace-$v.txt ~/.cache/claude-152/tree-$v/build/compiler --lanes 8 -c *.c 2>/dev/null; done
for r in 1 2 3; do
for v in 8 p1 p2; do
C=~/.cache/claude-152/tree-$v/build/compiler
for l in 1 8; do
rm -f ./*.o
perf stat -x, -e task-clock,context-switches -o stat.csv $C --lanes $l -c *.c 2> /dev/null
s=$?
w=$( { /usr/bin/env bash -c "TIMEFORMAT=%R; time $C --lanes $l -c *.c 2>/dev/null" ; } 2>&1 )
echo "round $r tree-$v lanes $l status=$s wall=${w}s $(grep -v "^#" stat.csv | grep -v "^$" | cut -d, -f1,3 | tr "\n" " ")"
done; done; done; rm -f ./*.o' > $L/many.log 2>&1
for v in p1 p2; do T=~/.cache/claude-152/tree-$v; (cd $T && mkdir -p build/c-testsuite/tests && ln -sfn ~/.cache/claude-152/c-testsuite/tests/single-exec build/c-testsuite/tests/single-exec && cores -n 4 -- ./build/compiler parallel --jobs 4 --timeout 600 < ~/.cache/claude-152/local5/units.list > $L/units-$v.log 2>&1; echo "exit=$?" >> $L/units-$v.log); done
echo all-done >> $L/many.log

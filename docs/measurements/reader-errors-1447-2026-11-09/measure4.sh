#!/bin/bash
D=~/buster-fast-bench/1447-claude-invalid
taskset -c 2 base/build/compiler time-runs --runs 11 --warmups 2 --build base $D/base/build/compiler --build atomic $D/atomic/build/compiler --build atomic2 $D/atomic2/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times-atomic2.txt 2>&1
for t in base:base/build/compiler atomic:atomic/build/compiler atomic2:atomic2/compiler; do
  n=${t%%:*}; b=${t#*:}
  taskset -c 2 perf record -q -e instructions:u -c 20000 -o perf-$n.data $b -fsyntax-only $D/sqlite3.c
done
echo TIMES-DONE >> times-atomic2.txt

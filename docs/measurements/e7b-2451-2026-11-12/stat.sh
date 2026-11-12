#!/bin/bash
# stat.sh TREE... : instructions:u of -fsyntax-only main.c and sqlite3.c per tree, default and with the warning off, three
# runs each, under one hold of the lock.
D=~/buster-fast-bench/e7b-claude
cd $D
M="-march=native -I$D/base91/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/base91/src/buster/compiler/main.c"
for t in "$@"; do
  for extra in "" "-Wno-tautological-constant-out-of-range-compare"; do
    for f in "$M" "$D/sqlite3.c"; do
      for r in 1 2 3; do
        n=$(taskset -c 2 perf stat -x, -e instructions:u $D/$t/build/compiler -fsyntax-only $extra $f 2>&1 >/dev/null | grep instructions | cut -d, -f1)
        echo "$t ${extra:-default} $(basename ${f##* }) $n"
      done
    done
  done
done

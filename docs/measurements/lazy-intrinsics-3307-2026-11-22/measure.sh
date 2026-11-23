#!/bin/sh
# usage: measure.sh TREE OUT  -- 11 runs each of imm1.c and sqlite3.c, eager and lazy, -fsyntax-only --time-stages
D=$HOME/buster-fast-bench/3307-claude
C=$D/$1/build/compiler
O=$D/$2
mkdir -p $O; cd $D
printf '#include <immintrin.h>\nint main(void){return 0;}\n' > imm1.c
cp -n $HOME/buster-fast-bench/653-claude/inputs/sqlite3.c sqlite3.c
for input in imm1 sqlite3; do
  for mode in eager lazy; do
    flag=""; [ $mode = lazy ] && flag=-flazy-system-headers
    for r in 1 2 3 4 5 6 7 8 9 10 11; do $C -w -fsyntax-only --time-stages $flag $input.c; done > $O/$input-$mode.stages 2>&1
  done
done

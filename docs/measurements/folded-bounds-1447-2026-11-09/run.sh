#!/bin/bash
D=~/buster-fast-bench/1447-claude-vlafold
cd $D
M="-fsyntax-only -march=native -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing $D/head/src/buster/compiler/main.c"
Q="-fsyntax-only $D/inputs/sqlite3.c"
for r in 1 2 3 4 5 6 7; do
  for t in base head; do
    for name in sqlite main; do
      if [ $name = sqlite ]; then a=$Q; else a=$M; fi
      v=$(taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock $D/$t/build/compiler $a 2>&1 >/dev/null | awk -F, '{printf "%s=%s ", $3, $1}')
      echo "round $r $t $name $v"
    done
  done
done

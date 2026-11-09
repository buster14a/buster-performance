#!/bin/bash
# #1923: pre = main before #1827 (cb608c1f), main = 4842317 (#1827 merged), fix = 627079e. znver5, built in the agent container.
D=~/buster-fast-bench/1447-claude-enum-cast
SQL=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
MAIN=$D/pre/src/buster/compiler/main.c
F="-march=native -I$D/pre/src -fwrapv -funsigned-char"
for round in 1 2 3; do
  for t in pre main fix; do
    echo "== round $round $t sqlite"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/bins/$t -fsyntax-only $SQL 2>&1
    echo "== round $round $t main.c"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 3 $D/bins/$t -fsyntax-only $F $MAIN 2>&1
  done
done

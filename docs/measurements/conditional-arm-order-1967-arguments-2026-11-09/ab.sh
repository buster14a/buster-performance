#!/bin/bash
# #1967 (#1895) review fix: base = main 9404cf0, head = bbe9acc. znver5, built in the agent container.
D=~/buster-fast-bench/1895-claude
SQL=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
MAIN=$D/src/buster/compiler/main.c
F="-march=native -I$D/src -fwrapv -funsigned-char"
for t in base3 head3; do $D/bins/$t -fsyntax-only $F $MAIN; echo "check $t main.c $?"; done
for round in 1 2 3; do
  for t in base3 head3; do
    echo "== round $round $t sqlite"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/bins/$t -fsyntax-only $SQL 2>&1
    echo "== round $round $t main.c"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 3 $D/bins/$t -fsyntax-only $F $MAIN 2>&1
  done
done

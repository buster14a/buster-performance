#!/bin/bash
# #1976 (#1835, #1836, #1837): error-free -fsyntax-only, main 784b580 against de3a1ce, both znver5 with no debug info,
# built in the session's container and copied here. One lock hold for the whole A/B.
set -u
D=~/buster-fast-bench/1976-claude
SQL=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
F="-march=native -I$D/src -fwrapv -funsigned-char"
for round in 1 2 3; do
  for t in base head; do
    echo "== round $round $t sqlite"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/compiler-$t -fsyntax-only $SQL 2>&1 >/dev/null
    echo "== round $round $t main.c"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/compiler-$t -fsyntax-only $F $D/src/buster/compiler/main.c 2>&1 >/dev/null
  done
done
echo RUN-DONE

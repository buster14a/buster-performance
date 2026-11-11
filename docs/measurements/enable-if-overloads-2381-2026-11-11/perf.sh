#!/bin/bash
# buster#2381: user instructions by symbol, base and head, -fsyntax-only of sqlite3.c (one lock hold per record).
D=~/buster-fast-bench/1447-claude-d3
cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: #2381 instructions by symbol"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2381
Q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
for t in pr-base pr-head; do
  ~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e instructions:u -c 20000 -o perf-$t.data $D/$t/build/compiler -fsyntax-only $Q
  perf report -i perf-$t.data --sort symbol --stdio -q 2>/dev/null | head -60 > perf-$t.txt
done
echo PERF-DONE

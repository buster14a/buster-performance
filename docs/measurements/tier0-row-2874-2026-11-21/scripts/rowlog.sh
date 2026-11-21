#!/bin/bash
# Usage: rowlog.sh BINARY TAG RUNS: -c sqlite3.c with BUSTER_ROW_LOG, CPU 2.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
rm -f rowlog-*.tsv
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-before.txt; cat /proc/loadavg >> busy-before.txt
for i in $(seq 1 $RUNS); do
  BUSTER_ROW_LOG=$D/results/$TAG/rowlog-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o $D/results/$TAG/sqlite3.o --time-stages 2> stages-$i.txt
  echo "run $i exit $?"
done
cmp $D/results/$TAG/sqlite3.o $D/results/main/sqlite3.o && echo "object same as main"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-after.txt; cat /proc/loadavg >> busy-after.txt

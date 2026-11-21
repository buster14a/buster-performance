#!/bin/bash
# Usage: stages.sh BINARY TAG RUNS. One -c sqlite3.c --time-stages a run, CPU 2.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-before.txt; cat /proc/loadavg >> busy-before.txt
for i in $(seq 1 $RUNS); do
  taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o $D/results/$TAG/sqlite3.o --time-stages 2> stages-$i.txt
  echo "run $i exit $?"
done
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-after.txt; cat /proc/loadavg >> busy-after.txt

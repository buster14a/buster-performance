#!/bin/bash
# Usage: calls.sh BINARY TAG RUNS: -c sqlite3.c with the row log at BUSTER_ROW_CALLS= 0, 1, 2, 4 in turn, CPU 2.
set -u
D=~/buster-fast-bench/2874-claude-rubin
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
rm -f rowlog-*.tsv
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  for n in 0 1 2 4; do
    mkdir -p n$n
    BUSTER_ROW_CALLS=$n BUSTER_ROW_LOG=$D/results/$TAG/n$n/rowlog-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG-$n.o --time-stages 2> n$n/stages-$i.txt
    echo "run $i calls $n exit $?"
  done
done
for n in 0 1 2 4; do sha256sum /dev/shm/2874-rubin-$TAG-$n.o; rm -f /dev/shm/2874-rubin-$TAG-$n.o; done > objects.sha256
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

#!/bin/bash
# Usage: windows.sh BINARY TAG RUNS: -c sqlite3.c --time-stages at --emit-window= 0, 2048, 8192, 32768, in turn, CPU 2.
set -u
D=~/buster-fast-bench/2874-claude-rubin
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  for w in 0 2048 8192 32768; do
    taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG-$w.o --time-stages --emit-window=$w 2> stages-w$w-$i.txt
    echo "run $i window $w exit $?"
  done
done
for w in 0 2048 8192 32768; do sha256sum /dev/shm/2874-rubin-$TAG-$w.o; rm -f /dev/shm/2874-rubin-$TAG-$w.o; done > objects.sha256
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

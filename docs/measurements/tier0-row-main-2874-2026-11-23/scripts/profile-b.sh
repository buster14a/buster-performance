#!/bin/bash
# Usage: profile-b.sh BINARY TAG RUNS PERIOD [EVENT]: RUNS perf records with branch stacks (-b) of -c sqlite3.c on CPU 2,
# the period two more each run (buster#2874). Then (post): brips charges libc's samples to their callers.
set -u
D=~/buster-fast-bench/2874-claude-rubin
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-8}; PERIOD=${4:-200003}; EVENT=${5:-cycles:u}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  perf record -q -b -e $EVENT -c $((PERIOD + 2 * i)) -o /dev/shm/2874-rubin-$TAG-$i.data -- taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG.o
  echo "run $i exit $?"
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

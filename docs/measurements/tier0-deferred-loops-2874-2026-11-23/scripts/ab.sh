#!/bin/bash
# Usage: ab.sh A B TAG ROUNDS: -c sqlite3.c --time-stages by A and B in turn, ROUNDS rounds, CPU 2 (buster#2874).
set -u
D=~/buster-fast-bench/2874-claude-rubin
C=$D/corpus
A=$1; B=$2; TAG=$3; ROUNDS=${4:-7}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG/a $D/results/$TAG/b
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $ROUNDS); do
  taskset -c 2 $A -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG-a.o --time-stages 2> a/stages-$i.txt; echo "round $i a exit $?"
  taskset -c 2 $B -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG-b.o --time-stages 2> b/stages-$i.txt; echo "round $i b exit $?"
done
{ sha256sum /dev/shm/2874-rubin-$TAG-a.o; sha256sum /dev/shm/2874-rubin-$TAG-b.o; } > objects.sha256
cmp /dev/shm/2874-rubin-$TAG-a.o /dev/shm/2874-rubin-$TAG-b.o && echo "objects same" >> objects.sha256
rm -f /dev/shm/2874-rubin-$TAG-a.o /dev/shm/2874-rubin-$TAG-b.o
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

#!/bin/bash
# Usage: ab.sh A B TAG ROUNDS [EXTRA...]: -c sqlite3.c --time-stages by A and B in turn, ROUNDS rounds, CPU 2, with
# EXTRA options to both (buster#2874). The caller holds the lock for the script.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
A=$1; B=$2; TAG=$3; ROUNDS=${4:-11}; shift 4 || shift $#
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG/a $D/results/$TAG/b
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
status=0
for i in $(seq 1 $ROUNDS); do
  taskset -c 2 $A -c $FLAGS "$@" $C/sqlite/sqlite3.c -o /dev/shm/2874-volta-$TAG-a.o --time-stages 2> a/stages-$i.txt || status=1
  taskset -c 2 $B -c $FLAGS "$@" $C/sqlite/sqlite3.c -o /dev/shm/2874-volta-$TAG-b.o --time-stages 2> b/stages-$i.txt || status=1
done
echo "exit status of every run: $status" > status.txt
{ sha256sum /dev/shm/2874-volta-$TAG-a.o; sha256sum /dev/shm/2874-volta-$TAG-b.o; } > objects.sha256
cmp /dev/shm/2874-volta-$TAG-a.o /dev/shm/2874-volta-$TAG-b.o && echo "objects same" >> objects.sha256
rm -f /dev/shm/2874-volta-$TAG-a.o /dev/shm/2874-volta-$TAG-b.o
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
$D/scripts/abtable.sh $D/results/$TAG | tee table.txt
cat status.txt objects.sha256

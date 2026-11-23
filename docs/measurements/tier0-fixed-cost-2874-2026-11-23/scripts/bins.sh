#!/bin/bash
# bins.sh BINARY TAG: the batch build's passes by a function's size (buster#2874): benchmark-backend-source's vector
# variant on sqlite3.c, 32 functions a batch, a run a stop, a bin of the functions' entry counts and an event pair
# (uops and mispredicts; op cache misses and slots the front end left empty). The caller holds the lock.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
: > bins.txt
BOUNDS=(0 8 16 32 64 128 256 512 1024 1000000)
for b in 0 1 2 3 4 5 6 7 8; do
  min=${BOUNDS[$b]}; max=${BOUNDS[$((b + 1))]}
  loops=81; if [ $max -le 128 ]; then loops=321; fi
  for s in 5 6 8 9 -1; do
    for e in c1,c3 20000048f,1000001a0; do
      line=$(BUSTER_TIER0_MIN=$min BUSTER_TIER0_MAX=$max BUSTER_TIER0_LOOPS=$loops BUSTER_TIER0_STOP=$s BUSTER_TIER0_GROUP=32 BUSTER_TIER0_EVENTS=$e taskset -c 2 $BIN benchmark-backend-source --only vector $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep '^census:')
      echo "min=$min max=$max events=$e $line" >> bins.txt
    done
  done
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
wc -l bins.txt

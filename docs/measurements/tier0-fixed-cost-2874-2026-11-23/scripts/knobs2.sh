#!/bin/bash
# knobs.sh BINARY TAG VARIABLE "VALUES" ROUNDS: -c sqlite3.c --time-stages with VARIABLE at each of VALUES, in turn, CPU
# 2, then benchmark-backend-source's vector variant in batches of 32 at each value with the retired and the microcoded
# uops (buster#2874). The caller holds the lock.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2; VAR=$3; VALUES=$4; ROUNDS=${5:-7}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
: > objects.txt
for i in $(seq 1 $ROUNDS); do
  for v in $VALUES; do
    env $VAR=$v taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-volta-$TAG.o --time-stages 2> stages-$v-$i.txt || echo "FAILED $v $i"
    sha256sum /dev/shm/2874-volta-$TAG.o | cut -c1-16 >> objects.txt
  done
done
rm -f /dev/shm/2874-volta-$TAG.o
sort -u objects.txt > objects-distinct.txt
for v in $VALUES; do
  line="$VAR=$v"
  for s in tier0 lower.validate branch-sizing encode unwind total; do
    m=$(grep -h -P "^time-stage\t$s\t" stages-$v-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')
    line="$line $s=$m"
  done
  echo "$line"
done | tee table.txt
for v in $VALUES; do
  for max in 1000000 64; do
    env $VAR=$v BUSTER_TIER0_MAX=$max BUSTER_TIER0_LOOPS=$([ $max = 64 ] && echo 321 || echo 41) BUSTER_TIER0_GROUP=32 BUSTER_TIER0_EVENTS=c1,224 taskset -c 2 $BIN benchmark-backend-source --only vector $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep '^census:' | sed "s/^/$VAR=$v max=$max /"
  done
done | tee benchmark.txt
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
cat objects-distinct.txt

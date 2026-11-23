#!/bin/bash
# scan.sh BINARY TAG ROUNDS: -c sqlite3.c --time-stages at each batch limit (BUSTER_TIER0_BATCH_JOBS, _ENTRIES), in turn,
# CPU 2 (buster#2874). The caller holds the lock.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2; ROUNDS=${3:-7}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
CONFIGS="1:2048 2:1000000000 4:1000000000 8:1000000000 32:256 32:512 32:1024 32:2048 32:4096 32:1000000000"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $ROUNDS); do
  for c in $CONFIGS; do
    j=${c%%:*}; e=${c##*:}
    BUSTER_TIER0_BATCH_JOBS=$j BUSTER_TIER0_BATCH_ENTRIES=$e taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-volta-$TAG.o --time-stages 2> stages-$j-$e-$i.txt || echo "FAILED $c $i"
    sha256sum /dev/shm/2874-volta-$TAG.o | cut -c1-16 >> objects.txt
  done
done
rm -f /dev/shm/2874-volta-$TAG.o
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
sort -u objects.txt > objects-distinct.txt
for c in $CONFIGS; do
  j=${c%%:*}; e=${c##*:}
  line="jobs=$j entries=$e"
  for s in tier0 branch-sizing encode unwind lower total; do
    m=$(grep -h -P "^time-stage\t$s\t" stages-$j-$e-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')
    line="$line $s=$m"
  done
  echo "$line"
done | tee table.txt
cat objects-distinct.txt

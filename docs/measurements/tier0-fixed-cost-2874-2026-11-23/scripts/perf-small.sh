#!/bin/bash
# perf-small.sh BINARY TAG MAX LOOPS: user-mode samples of benchmark-backend-source's vector variant over sqlite3.c's
# functions of fewer than MAX entries, 32 a batch, LOOPS loops, on CPU 2: the sampled addresses counted
# (results/TAG/EVENT.ips: count address), for a table by function and line made where the unstripped executable is
# (buster#2874). The caller holds the lock.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2; MAX=$3; LOOPS=$4
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
: > events.txt
EVENTS="cycles:cycles:150011 instructions:instructions:400009 uops:rc1:400009 misp:rc3:1009 opcache-miss:r20000048f:5003 fe-empty:r1000001a0:400009"
for spec in $EVENTS; do
  name=${spec%%:*}; rest=${spec#*:}; event=${rest%%:*}; period=${rest##*:}
  BUSTER_TIER0_MAX=$MAX BUSTER_TIER0_LOOPS=$LOOPS BUSTER_TIER0_GROUP=32 perf record -q -e $event:u -c $period -o /dev/shm/2874-volta-perf.data -- taskset -c 2 $BIN benchmark-backend-source --only vector $FLAGS $C/sqlite/sqlite3.c > census-$name.txt 2>&1
  perf script -i /dev/shm/2874-volta-perf.data -F ip 2>/dev/null | sort | uniq -c | awk '{print $1, $2}' > $name.ips
  echo "$name period=$period runs=1 samples=$(awk '{s+=$1} END {print s}' $name.ips)" >> events.txt
done
rm -f /dev/shm/2874-volta-perf.data
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
cat events.txt; grep -h census: census-cycles.txt

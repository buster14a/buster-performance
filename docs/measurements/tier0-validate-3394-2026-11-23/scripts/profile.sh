#!/bin/bash
# Usage: profile.sh BINARY TAG RUNS PERIOD [EVENT]: perf records of -c sqlite3.c on CPU 2, the period two more each
# run, kept in /dev/shm for profile-post.sh (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}; PERIOD=${4:-20011}; EVENT=${5:-cycles:u}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
test -x $BIN || { echo "missing $BIN"; exit 1; }
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  perf record -q -e $EVENT -c $((PERIOD + 2 * i)) -o /dev/shm/3394-claude-$TAG-$i.data -- taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/3394-claude-$TAG.o
  echo "run $i exit $?"
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

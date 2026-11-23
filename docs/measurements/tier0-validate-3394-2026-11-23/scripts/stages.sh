#!/bin/bash
# Usage: stages.sh BINARY TAG RUNS [ENV=VALUE...]. One -c sqlite3.c --time-stages a run, CPU 2 (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-7}; shift 3
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
test -x $BIN || { echo "missing $BIN"; exit 1; }
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  env "$@" taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/3394-claude-$TAG.o --time-stages 2> stages-$i.txt
  echo "run $i exit $?"
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
sha256sum /dev/shm/3394-claude-$TAG.o > object.sha256
rm -f /dev/shm/3394-claude-$TAG.o

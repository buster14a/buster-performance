#!/bin/bash
# Usage: rowlog.sh BINARY TAG RUNS [warm]: -c sqlite3.c with BUSTER_ROW_LOG (and BUSTER_ROW_WARM with `warm`), CPU 2.
set -u
D=~/buster-fast-bench/2874-claude-rubin
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-5}; WARM=${4:-}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
rm -f rowlog-*.tsv
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
for i in $(seq 1 $RUNS); do
  if [ -n "$WARM" ]; then
    BUSTER_ROW_WARM=$WARM BUSTER_ROW_LOG=$D/results/$TAG/rowlog-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG.o --time-stages 2> stages-$i.txt
  else
    BUSTER_ROW_LOG=$D/results/$TAG/rowlog-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-rubin-$TAG.o --time-stages 2> stages-$i.txt
  fi
  echo "run $i exit $?"
done
sha256sum /dev/shm/2874-rubin-$TAG.o > object.sha256
rm -f /dev/shm/2874-rubin-$TAG.o
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt

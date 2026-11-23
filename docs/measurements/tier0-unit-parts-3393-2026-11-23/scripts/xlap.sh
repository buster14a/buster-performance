#!/bin/bash
# xlap.sh BIN TAG RUNS: the experiment laps (BUSTER_XLAP=1) and the stage clock, CPU 2.
set -u
D=~/buster-fast-bench/3393-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-7}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG; cd $D/results/$TAG
for i in $(seq 1 $RUNS); do
  BUSTER_XLAP=1 taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/3393-$TAG.o --time-stages 2> stages-$i.txt
  echo "run $i exit $?"
done
sha256sum /dev/shm/3393-$TAG.o > object.sha256; rm -f /dev/shm/3393-$TAG.o

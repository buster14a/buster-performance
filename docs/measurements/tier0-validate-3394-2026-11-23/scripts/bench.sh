#!/bin/bash
# Usage: bench.sh BINARY TAG RUNS: benchmark-backend-source --only validate on sqlite3.c, RUNS processes, CPU 2 (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
C=$D/corpus
BIN=$1; TAG=$2; RUNS=${3:-3}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
test -x $BIN || { echo "missing $BIN"; exit 1; }
mkdir -p $D/results/$TAG
cd $D/results/$TAG
for i in $(seq 1 $RUNS); do
  taskset -c 2 $BIN benchmark-backend-source --only validate $FLAGS $C/sqlite/sqlite3.c > bench-$i.txt 2>&1
  echo "bench $i exit $?"
done

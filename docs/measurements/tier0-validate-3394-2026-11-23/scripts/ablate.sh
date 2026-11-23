#!/bin/bash
# Usage: ablate.sh BINARY TAG ROUNDS SKIP...: benchmark-backend-source --only validate on sqlite3.c with each
# BUSTER_3394_SKIP value, ROUNDS rotations, CPU 2 (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
C=$D/corpus
BIN=$1; TAG=$2; ROUNDS=$3; shift 3
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
test -x $BIN || { echo "missing $BIN"; exit 1; }
mkdir -p $D/results/$TAG
cd $D/results/$TAG
for r in $(seq 1 $ROUNDS); do
  for k in "$@"; do
    BUSTER_3394_SKIP=$k taskset -c 2 $BIN benchmark-backend-source --only validate $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep "^validate" | sed "s/^/skip=$k round=$r /" >> ablate.txt
  done
done

#!/bin/bash
# Usage: profbench.sh BINARY TAG EVENT PERIOD: a perf record of benchmark-backend-source --only validate on sqlite3.c,
# CPU 2, kept in /dev/shm for profbench-post.sh (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
C=$D/corpus
BIN=$1; TAG=$2; EVENT=${3:-cycles:u}; PERIOD=${4:-100003}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
test -x $BIN || { echo "missing $BIN"; exit 1; }
mkdir -p $D/results/$TAG
cd $D/results/$TAG
perf record -q -e $EVENT -c $PERIOD -o /dev/shm/3394-claude-$TAG.data -- taskset -c 2 $BIN benchmark-backend-source --only validate $FLAGS $C/sqlite/sqlite3.c > bench-prof.txt 2>&1
echo "record exit $?"

#!/bin/bash
# Usage: bytesfake.sh BINARY TAG: the shadow with and without its lookups faked, sqlite3.c, CPU 2.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
taskset -c 2 $BIN measure-tier0-bytes --passes 5 $FLAGS $C/sqlite/sqlite3.c > real.txt 2>&1
BUSTER_TIER0_BYTES_FAKE=1 taskset -c 2 $BIN measure-tier0-bytes --passes 5 $FLAGS $C/sqlite/sqlite3.c > fake.txt 2>&1
grep "ticks an entry\|lap" real.txt fake.txt

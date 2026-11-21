#!/bin/bash
# Usage: bytes.sh BINARY TAG [PASSES]: measure-tier0-bytes on sqlite3.c, CPU 2.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2; PASSES=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-before.txt; cat /proc/loadavg >> busy-before.txt
taskset -c 2 $BIN measure-tier0-bytes --passes $PASSES $FLAGS $C/sqlite/sqlite3.c > sqlite3.txt 2>&1
echo "exit $?" >> sqlite3.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-after.txt; cat /proc/loadavg >> busy-after.txt
cat sqlite3.txt

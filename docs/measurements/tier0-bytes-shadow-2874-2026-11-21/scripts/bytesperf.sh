#!/bin/bash
# Usage: bytesperf.sh BINARY TAG: perf record of measure-tier0-bytes on sqlite3.c, CPU 2; annotate the shadow's functions.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
perf record -q -e cycles:u -c 50000 -o perf.data -- taskset -c 2 $BIN measure-tier0-bytes --passes 5 $FLAGS $C/sqlite/sqlite3.c > out.txt 2>&1
perf report -i perf.data --no-children --sort sym --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > report.txt
perf annotate -i perf.data --stdio -s tier0_bytes_function 2>/dev/null > annotate-function.txt
perf annotate -i perf.data --stdio -s tier0_bytes_shape 2>/dev/null > annotate-shape.txt
perf stat -e cycles:u,instructions:u,branch-misses:u -o stat.txt -- taskset -c 2 $BIN measure-tier0-bytes --passes 5 $FLAGS $C/sqlite/sqlite3.c > /dev/null 2>&1
echo done

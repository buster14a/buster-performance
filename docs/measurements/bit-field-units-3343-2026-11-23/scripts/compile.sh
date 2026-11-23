#!/bin/bash
# Compile time of base and head under one hold of the lock: the frozen sqlite3.c's -c and --tier1 -c (the corpus's
# pinned predefines and headers), by time-runs, 21 runs each after 2 warm-ups, on CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1372-3343-claude
corpus=$1
mode=$2
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > out/busy-compile-$mode.txt
sha256sum "$corpus/MANIFESTS.sha256" "$corpus/sqlite/sqlite3.c" > out/corpus.sha256
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include"
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0)
extra=()
[ "$mode" = tier1 ] && extra=(--tier1)
taskset -c 2 bin/compiler-head time-runs --runs 21 --warmups 2 --build base bin/compiler-base --build head bin/compiler-head \
    --list -c "${extra[@]}" "${options[@]}" "$corpus/sqlite/sqlite3.c" -o /tmp/3343-sqlite-$mode.o > out/time-sqlite-$mode.txt 2>&1
rm -f /tmp/3343-sqlite-$mode.o

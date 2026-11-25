#!/bin/bash
# ibs.sh NAME: precise retired-op samples (AMD IBS op) by symbol and symbol+srcline for bin/direct-NAME, 40 compiles.
set -uo pipefail
here=$HOME/buster-fast-bench/3581-claude-hape45
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1/ -c 20011 -o "$out/ibs.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/hape45.o --repeat 40 > "$out/ibs.log" 2>&1
rm -f /dev/shm/hape45.o

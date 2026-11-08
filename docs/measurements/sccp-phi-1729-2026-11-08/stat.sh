#!/bin/bash
# One lock hold: perf stat's user instructions and cycles of -c --tier1 --lanes 1 sqlite3.c, 5 runs per binary.
set -u
D=$HOME/buster-fast-bench/1729-opencode
C=$HOME/buster-fast-bench/corpus-391e729af658
for b in ${BINARIES:-base head}; do
    echo "== $b"
    taskset -c 2 perf stat -x, -r 5 -e instructions:u,cycles:u,branch-misses:u -- "$D/bin/$b" -c --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" -o "$D/out/stat.$b.o" 2>&1 >/dev/null | grep -E '^[0-9.]+,'
done

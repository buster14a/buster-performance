#!/usr/bin/env bash
# stat3.sh TREE...: perf stat of 5 runs of each tree's --tier1 -c of the frozen sqlite3.c, rotating, 3 rounds.
Q=~/.cache/claude-frozen-corpus/sqlite
cd ~/.cache/claude-1116/prof || exit 1
for r in 1 2 3; do
    for t in "$@"; do
        taskset -c 1 perf stat -x, -e instructions:u,cycles:u,branch-misses:u -r 5 -o stat3-$t-$r.csv ~/.cache/claude-1116/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$Q -o s3-$t.o $Q/sqlite3.c
    done
done
for t in "$@"; do
    awk -F, -v t=$t '$3 ~ /instructions/ {i+=$1; n++} $3 ~ /cycles/ {c+=$1} $3 ~ /branch-misses/ {b+=$1} END {printf "%s instructions %.2f M cycles %.2f M branch-misses %.3f M\n", t, i/n/1e6, c/n/1e6, b/n/1e6}' stat3-$t-*.csv
done

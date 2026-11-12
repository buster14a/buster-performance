#!/bin/bash
# usage: lock.sh ./tier1cost.sh ; what --tier1 costs a compile of the frozen sqlite3.c against the default tier, by
# measure-compile's own variant comparison (whole processes, a Williams design's order), pinned to CPU 2.
# Results in results/tier1cost. The tree is d96b2e73 with inventory-dump.patch (a measuring command's patch).
set -u
cd "$(dirname "$0")"
out=results/tier1cost
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
compiler=src/build/compiler
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/identity.txt"
taskset -c 2 "$compiler" measure-compile --runs 7 --variant --tier1 -- "${options[@]}" > "$out/measure-compile.txt" 2>&1
echo "status $?" >> "$out/measure-compile.txt"
taskset -c 2 "$compiler" --tier1 --tier1-report "${options[@]}" -o scratch/sqlite3-tier1.o > "$out/tier1-report.txt" 2>&1
echo "status $?" >> "$out/tier1-report.txt"
date -u +%FT%TZ > "$out/done"

#!/bin/bash
# Usage: bp-ab.sh OUT TREE... -- the walk's parts (measure-compile) per tree, then rotated whole processes (ab + time-runs)
out="$1"; shift
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for round in 1 2; do
for tree in "$@"; do
  name=$(basename "$tree")
  ~/buster-fast-bench/exclusive.sh taskset -c 2 "$tree/build/compiler" measure-compile --runs 11 -- "${options[@]}" > "$out/measure-$name-$round.txt" 2>&1
done
done
first="$1"
"$first/build/compiler" ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$@" -- time-runs --runs 11 --list "${options[@]}" -o "$out/ab.o" > "$out/ab.txt" 2>&1
for tree in "$@"; do
  name=$(basename "$tree")
  ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -r 11 -e task-clock,cycles:u,instructions:u,cycles:k,branch-misses:u -o "$out/stat-$name.txt" -- "$tree/build/compiler" "${options[@]}" -o "$out/stat.o"
done
echo done > "$out/done"

#!/usr/bin/env bash
set -euo pipefail
root=$1
side=$2
shift=$3
mode=$4
sqlite="$root/corpus/sqlite"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$root/head"
if [ "$mode" = stages ]; then
  taskset -c 2 "$root/$side-shifts/compiler-$shift" measure-compile --runs 11 -- "${options[@]}"
else
  taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,branch-misses:u,ls_bad_status2.stli_other:u -- "$root/$side-shifts/compiler-$shift" "${options[@]}" -o "$root/counted.o"
fi

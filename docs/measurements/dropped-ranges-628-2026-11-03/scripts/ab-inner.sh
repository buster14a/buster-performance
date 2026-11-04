#!/bin/bash
set -e
a=$1; b=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$a" "${options[@]}" -o "$out/reference.o"
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) = 1 ]; then order="A B"; else order="B A"; fi
    for v in $order; do
        if [ $v = A ]; then exe=$a; else exe=$b; fi
        taskset -c 2 "$exe" "${options[@]}" -o "$out/warm-$v.o"
        taskset -c 2 perf stat -r 3 -x, -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults -o "$out/stat-$v-$round.csv" -- "$exe" "${options[@]}" -o "$out/$v.o"
        cmp "$out/reference.o" "$out/$v.o"
    done
done
taskset -c 2 "$a" measure-compile --runs 11 --directory "$out" --reference "$b" -- "${options[@]}" > "$out/measure-A.txt" 2>&1
taskset -c 2 "$b" measure-compile --runs 11 --directory "$out" --reference "$a" -- "${options[@]}" > "$out/measure-B.txt" 2>&1

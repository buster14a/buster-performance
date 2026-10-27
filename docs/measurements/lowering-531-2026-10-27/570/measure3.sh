#!/usr/bin/env bash
set -u
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
out=$PWD/out3
mkdir -p "$out"
for t in main v4; do
    taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" || echo "compile $t failed"
done
cmp "$out/main.o" "$out/v4.o" && echo "object: main == v4"
events=task-clock,cycles:u,instructions:u,cycles:k
orders=("main v2 v4" "v2 v4 main" "v4 main v2")
for round in 1 2 3 4 5 6 7 8 9; do
    for t in ${orders[$((round % 3))]}; do
        taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/warm.o"
        taskset -c 2 perf stat -r 3 -x, -e "$events" -o "$out/stat-$t-$round.txt" -- "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o"
    done
done
bench=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for t in v2 v4 v2 v4; do
    taskset -c 2 "./$t/build/compiler" benchmark-check-lanes --passes 11 --lanes 1 "${bench[@]}" 2>&1 | grep "forced=1" | sed "s/^/$t /" >> "$out/lanes.txt"
done
echo measured

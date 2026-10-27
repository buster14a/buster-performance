#!/usr/bin/env bash
set -u
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
out=$PWD/out4
mkdir -p "$out"
for t in main final final-520; do
    taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" || echo "compile $t failed"
done
for t in final final-520; do
    cmp "$out/main.o" "$out/$t.o" && echo "object: main == $t"
done
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k
for round in 1 2 3 4 5 6 7 8 9 10; do
    if [ $((round % 2)) -eq 1 ]; then order="main final"; else order="final main"; fi
    for t in $order; do
        taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/warm.o"
        taskset -c 2 perf stat -r 3 -x, -e "$events" -o "$out/stat-$t-$round.txt" -- "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o"
    done
done
taskset -c 2 ./final-520/build/compiler measure-compile --runs 11 --reference "$PWD/main520/build/compiler" -- "${opts[@]}" > "$out/mc-final-vs-main.txt" 2>&1
taskset -c 2 ./main520/build/compiler measure-compile --runs 11 --reference "$PWD/final-520/build/compiler" -- "${opts[@]}" > "$out/mc-main-vs-final.txt" 2>&1
bench=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for t in main final main final; do
    taskset -c 2 "./$t/build/compiler" benchmark-check-lanes --passes 11 --lanes 1 "${bench[@]}" 2>&1 | grep "forced=1" | sed "s/^/$t /" >> "$out/lanes.txt"
done
echo measured

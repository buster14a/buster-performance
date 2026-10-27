#!/usr/bin/env bash
# One hold: v2's object against main's, perf stat rounds of main, v1 and v2 in rotating order (each after a warm-up of its
# own), measure-compile of v2 with main as its reference (#520's stage report), peak RSS, the one-lane emission benchmark.
set -u
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
out=$PWD/out2
mkdir -p "$out"
for t in main v2 v2-520; do
    taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" || echo "compile $t failed"
done
for t in v2 v2-520; do
    cmp "$out/main.o" "$out/$t.o" && echo "object: main == $t"
done
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k
orders=("main v1 v2" "v1 v2 main" "v2 main v1")
for round in 1 2 3 4 5 6 7 8 9; do
    for t in ${orders[$((round % 3))]}; do
        taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/warm.o"
        taskset -c 2 perf stat -r 3 -x, -e "$events" -o "$out/stat-$t-$round.txt" -- "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o"
    done
done
taskset -c 2 ./v2-520/build/compiler measure-compile --runs 11 --reference "$PWD/main520/build/compiler" -- "${opts[@]}" > "$out/mc-v2-vs-main.txt" 2>&1
taskset -c 2 ./main520/build/compiler measure-compile --runs 11 --reference "$PWD/v2-520/build/compiler" -- "${opts[@]}" > "$out/mc-main-vs-v2.txt" 2>&1
for i in 1 2 3; do
    for t in main v2; do
        /usr/bin/time -f "$t maxrss_kb=%M elapsed=%e user=%U sys=%S minor=%R" taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" 2>> "$out/time.txt"
    done
done
bench=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for t in main v2 main v2; do
    taskset -c 2 "./$t/build/compiler" benchmark-check-lanes --passes 11 --lanes 1 "${bench[@]}" 2>&1 | grep "forced=1" | sed "s/^/$t /" >> "$out/lanes.txt"
done
echo measured

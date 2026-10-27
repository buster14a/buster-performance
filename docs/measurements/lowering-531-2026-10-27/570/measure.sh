#!/usr/bin/env bash
# One hold: the objects compared, perf stat rounds of -c of the frozen sqlite3.c (#520's step's options), main and the
# branch alternated, each after a warm-up of its own; measure-compile both ways (#520's stage report); peak RSS; and the
# one-lane emission benchmark (warm memory).
set -u
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
out=${OUT:-$PWD/out}
mkdir -p "$out"
for t in main v1 main520 v1-520; do
    taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" || echo "compile $t failed"
done
for t in v1 main520 v1-520; do
    cmp "$out/main.o" "$out/$t.o" && echo "object: main == $t"
done
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then order="main v1"; else order="v1 main"; fi
    for t in $order; do
        taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/warm.o"
        taskset -c 2 perf stat -r 3 -x, -e "$events" -o "$out/stat-$t-$round.txt" -- "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o"
    done
done
taskset -c 2 ./v1-520/build/compiler measure-compile --runs 11 --reference "$PWD/main520/build/compiler" -- "${opts[@]}" > "$out/mc-v1-vs-main.txt" 2>&1
taskset -c 2 ./main520/build/compiler measure-compile --runs 11 --reference "$PWD/v1-520/build/compiler" -- "${opts[@]}" > "$out/mc-main-vs-v1.txt" 2>&1
for i in 1 2 3; do
    for t in main v1; do
        /usr/bin/time -f "$t maxrss_kb=%M elapsed=%e user=%U sys=%S minor=%R" taskset -c 2 "./$t/build/compiler" "${opts[@]}" -o "$out/$t.o" 2>> "$out/time.txt"
    done
done
bench=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for t in main v1 main v1; do
    taskset -c 2 "./$t/build/compiler" benchmark-check-lanes --passes 11 --lanes 1 "${bench[@]}" 2>&1 | grep "forced=1" | sed "s/^/$t /" >> "$out/lanes.txt"
done
echo measured

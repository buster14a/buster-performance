#!/bin/bash
# What the default warnings cost sqlite3.c's compile on the 9700X today: the job's build of main ef3d4475f, the default
# compile against -w, in ABBA order. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
C=build/compiler-job-ef3d4475f
out=../results/warnings-ef3d4475f
mkdir -p "$out"
O=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
taskset -c 2 "$C" "${O[@]}" -o "$out/default.o" 2> "$out/default.err"; echo "status=$?" >> "$out/default.err"
taskset -c 2 "$C" -w "${O[@]}" -o "$out/w.o" 2> "$out/w.err"; echo "status=$?" >> "$out/w.err"
cmp "$out/default.o" "$out/w.o" > "$out/cmp.txt" 2>&1; echo "cmp=$?" >> "$out/cmp.txt"
for round in 1 2; do
    for variant in default w w default; do
        extra=()
        [ "$variant" = w ] && extra=(-w)
        taskset -c 2 "$C" measure-compile --runs 5 -- "${extra[@]}" "${O[@]}" >> "$out/measure-$variant.txt" 2>&1; echo "status=$?" >> "$out/measure-$variant.txt"
    done
done
{ date -u; cat /proc/loadavg; } > "$out/after.txt"
echo done > "$out/complete"

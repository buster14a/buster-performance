#!/bin/bash
# The state of main at 16ccdccd on the 9700X: sqlite3.c's default compile, its instructions against the baseline,
# its stages, and the same with --node-bodies. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
C=./build/compiler-16ccdccd
out=../results/main-16ccdccd
mkdir -p "$out"
O=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/before.txt"
taskset -c 2 "$C" "${O[@]}" -o "$out/warm.o" 2> "$out/warm.err"; echo "status=$?" >> "$out/warm.err"
sha256sum "$out/warm.o" > "$out/object.sha256"
taskset -c 2 "$C" measure-compile --runs 7 --instructions-baseline tools/ci/compile-instructions.txt -- "${O[@]}" > "$out/measure.txt" 2>&1; echo "status=$?" >> "$out/measure.txt"
for i in 1 2 3 4 5; do
    taskset -c 2 "$C" --lanes 1 "${O[@]}" -o "$out/plain.o" --time-stages 2> "$out/stages-plain-$i.txt"; echo "status=$?" >> "$out/stages-plain-$i.txt"
    taskset -c 2 "$C" --node-bodies --lanes 1 "${O[@]}" -o "$out/bodies.o" --time-stages 2> "$out/stages-bodies-$i.txt"; echo "status=$?" >> "$out/stages-bodies-$i.txt"
done
cmp "$out/plain.o" "$out/bodies.o" > "$out/cmp.txt" 2>&1; echo "cmp=$?" >> "$out/cmp.txt"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/after.txt"
echo done > "$out/complete"

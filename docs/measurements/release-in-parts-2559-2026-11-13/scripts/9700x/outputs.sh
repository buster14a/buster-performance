#!/bin/bash
# The base's and the head's executables write the same outputs (inside the lock): sqlite3.c's -c at both tiers and -E,
# and every main.c unit's -c and -E with the compiler's own flags. Results to results/outputs.txt.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
. "$d/scripts/env.sh"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
out=$d/scratch/outputs
rm -rf "$out"; mkdir -p "$out/base" "$out/head"
cd "$d/base" || exit 2
sqlite=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
own=(-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing)
same=0; differ=0; failed=0
for side in base head; do
    c=$d/placements/$side/compiler-0
    taskset -c 2 "$c" -c "${sqlite[@]}" -o "$out/$side/sqlite.o" || failed=$((failed + 1))
    taskset -c 2 "$c" -c --tier1 "${sqlite[@]}" -o "$out/$side/sqlite-tier1.o" || failed=$((failed + 1))
    taskset -c 2 "$c" -E "${sqlite[@]}" -o "$out/$side/sqlite.i" || failed=$((failed + 1))
    for unit in src/buster/compiler/main.c src/buster/compiler/main_unit_*.c; do
        n=$(basename "$unit" .c)
        taskset -c 2 "$c" -c "${own[@]}" "$unit" -o "$out/$side/$n.o" > "$out/$side/$n.c.log" 2>&1 || failed=$((failed + 1))
        taskset -c 2 "$c" -c --tier1 "${own[@]}" "$unit" -o "$out/$side/$n.tier1.o" > "$out/$side/$n.tier1.log" 2>&1 || failed=$((failed + 1))
        taskset -c 2 "$c" -E "${own[@]}" "$unit" -o "$out/$side/$n.i" > "$out/$side/$n.E.log" 2>&1 || failed=$((failed + 1))
    done
done
for f in "$out"/base/*; do
    n=$(basename "$f")
    if cmp -s "$f" "$out/head/$n"; then same=$((same + 1)); else differ=$((differ + 1)); echo "differs: $n"; fi
done > "$d/results/outputs-differences.txt"
printf 'outputs: %s the same, %s differ, %s commands failed (files of both sides: %s)\n' "$same" "$differ" "$failed" "$(ls "$out/base" | wc -l)" | tee "$d/results/outputs.txt"
sha256sum "$out"/base/*.o "$out"/base/*.i >> "$d/results/outputs.txt"

#!/bin/bash
# ablation-runs.sh: ablation.sh's runs, in one hold; ablation/runs.txt has a line a run: the round, the build or variant,
# the file, then its selection-census-ticks fields.
set -u
here=$PWD
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
out=$here/ablation
mkdir -p "$out/o"
: > "$out/runs.txt"
sides="base v0 v1 v2 v4 v8"
for run in 1 2 3 4 5 6 7; do
    order=$(echo $sides | tr ' ' '\n' | awk -v r=$run '{ a[NR] = $0 } END { for (i = 0; i < NR; i++) print a[(i + r) % NR + 1] }')
    for side in $order; do
        compiler=$here/compiler-variant
        variant=${side#v}
        [ "$side" = base ] && compiler=$here/compiler-base && variant=0
        (cd "$corpus/sqlite" && BUSTER_PASS_VARIANT=$variant taskset -c 2 "$compiler" --selection-census --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" -c "$corpus/sqlite/sqlite3.c" -o "$out/o/s.o" 2> "$out/o/s.err" < /dev/null)
        printf '%s\t%s\tsqlite\t%s\n' "$run" "$side" "$(grep '^selection-census-ticks' "$out/o/s.err" | cut -f2-)" >> "$out/runs.txt"
        (cd "$here/head" && BUSTER_PASS_VARIANT=$variant taskset -c 2 "$compiler" --selection-census --lanes 1 -march=native -Isrc -fwrapv -funsigned-char -c "$here/head/src/buster/compiler/main.c" -o "$out/o/m.o" 2> "$out/o/m.err" < /dev/null)
        printf '%s\t%s\tmain\t%s\n' "$run" "$side" "$(grep '^selection-census-ticks' "$out/o/m.err" | cut -f2-)" >> "$out/runs.txt"
    done
done

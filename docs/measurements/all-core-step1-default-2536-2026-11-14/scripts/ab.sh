#!/bin/bash
# ab.sh COMPILER OUT: sqlite3.c's -c on CPU 2, the driver's default and --emit-window=0 alternating, 15 runs each, each
# counted by perf stat (user cycles, user instructions). One hold of the lock.
set -u
compiler=$1 out=$2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p "$out"
: > "$out/runs.tsv"
for i in $(seq 1 15); do
    for variant in default w0; do
        option=(); [ $variant = w0 ] && option=(--emit-window=0)
        perf stat -x, -e cycles:u,instructions:u,cycles:k -o "$out/s.txt" -- taskset -c 2 "$compiler" --lanes 1 "${option[@]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/$variant.o"
        printf "%s\t%s\t%s\n" "$i" "$variant" "$(awk -F, '/cycles:u|instructions:u|cycles:k/ { printf "%s\t", $1 }' "$out/s.txt")" >> "$out/runs.tsv"
    done
done
cmp "$out/default.o" "$out/w0.o" && echo "objects same" >> "$out/runs.tsv"

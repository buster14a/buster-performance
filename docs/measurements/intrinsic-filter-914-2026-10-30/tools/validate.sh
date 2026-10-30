#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
mkdir -p results/validation
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
for revision in base fixed; do
    for placement in 0 64 256; do
        compiler="placement-$revision/compiler-$placement"
        sha256sum "$compiler"
        for path in vector scalar; do
            mode=()
            if [ "$path" = scalar ]; then mode=(--scalar); fi
            output="results/validation/$revision-$placement-$path"
            taskset -c 2 "$compiler" "${mode[@]}" "${sqlite[@]}" -o "$output-sqlite.o"
            taskset -c 2 "$compiler" "${mode[@]}" -march=znver5 -c tiny.c -o "$output-tiny.o"
            cmp results/validation/base-0-vector-sqlite.o "$output-sqlite.o"
            cmp results/validation/base-0-vector-tiny.o "$output-tiny.o"
            taskset -c 2 "$compiler" "${mode[@]}" -march=znver5 tiny.c -o "$output-tiny"
            status=0
            "$output-tiny" || status=$?
            test "$status" = 21
            printf 'validated revision=%s placement=%s path=%s tiny_exit=%s\n' "$revision" "$placement" "$path" "$status"
        done
    done
done
sha256sum results/validation/base-0-vector-sqlite.o results/validation/base-0-vector-tiny.o

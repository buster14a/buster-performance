#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
case "$1" in
    validate)
        sha256sum setup-base setup-fixed setup_runner
        taskset -c 2 ./setup_runner --self-test
        for revision in base fixed; do
            taskset -c 2 "./setup-$revision" "${sqlite[@]}" -o "results/setup-$revision-sqlite.o"
            cmp results/validation/base-0-vector-sqlite.o "results/setup-$revision-sqlite.o"
            taskset -c 2 "./setup-$revision" -c -march=znver5 tiny.c -o "results/setup-$revision-tiny.o"
            cmp results/validation/base-0-vector-tiny.o "results/setup-$revision-tiny.o"
        done
        printf 'setup adapter objects match shipping SQLite and tiny outputs\n'
        ;;
    sqlite)
        taskset -c 2 ./setup_runner "$PWD/setup-base" "$PWD/setup-fixed" 21 1 -- "${sqlite[@]}" -o "$PWD/results/setup-measured-sqlite.o"
        ;;
    tiny)
        taskset -c 2 ./setup_runner "$PWD/setup-base" "$PWD/setup-fixed" 51 1 -- -c -march=znver5 tiny.c -o "$PWD/results/setup-measured-tiny.o"
        ;;
    *) exit 2 ;;
esac

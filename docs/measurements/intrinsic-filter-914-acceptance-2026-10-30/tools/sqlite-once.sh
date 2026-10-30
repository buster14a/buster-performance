#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-acceptance-20261030"
revision="$1"
runs="${2:-30}"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
for ((run=0; run<runs; run+=1)); do
    taskset -c 2 "$revision/compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c" -o "results/$revision-sqlite.o"
done

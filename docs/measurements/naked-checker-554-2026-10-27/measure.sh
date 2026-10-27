#!/usr/bin/env bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-554/head
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source_args=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
sha256sum ../base/build/compiler build/compiler "$corpus/sqlite/sqlite3.c"
../base/build/compiler -fsyntax-only "${source_args[@]}"
./build/compiler -fsyntax-only "${source_args[@]}"
echo 'Both syntax-only preflights succeeded'
./build/compiler time-runs --runs 9 --warmups 2 --copies 3 --build base ../base/build/compiler --build head build/compiler --list -fsyntax-only "${source_args[@]}"

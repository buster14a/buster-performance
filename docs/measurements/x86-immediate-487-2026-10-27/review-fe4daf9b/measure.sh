#!/usr/bin/env bash
set -euo pipefail
root=${1:?measurement directory}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
base="$root/base/build/compiler"
fix="$root/head/build/compiler"
mkdir -p "$root/copies"
source_options=(-march=znver5 -std=gnu17 -nostdinc
    -isystem "$corpus/headers/usr/lib/clang/23/include"
    -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include")
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for input in small valid dead compound sqlite; do
    path="$root/$input.c"
    if [[ "$input" == sqlite ]]; then
        path="$corpus/sqlite/sqlite3.c"
    fi
    EXCLUSIVE_OWNER=codex-487 EXCLUSIVE_TITLE="PR 561 review $input matched cost screen" \
        EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/561 \
        "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "$fix" time-runs \
        --runs 11 --warmups 2 --copies 3 --directory "$root/copies" \
        --build base-a "$base" --build base-b "$base" --build fix "$fix" \
        --list -fsyntax-only "${source_options[@]}" "$path" > "$root/$input-times.log" 2>&1
done

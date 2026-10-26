#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    tree="${spec%%:*}"; c="${spec#*:}"
    compiler="$root/$tree/build/compiler"
    echo "== round $round case $spec $(date +%T)"
    case "$c" in
        pp-sqlite) taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "$inputs/sqlite3.c" 2>&1 ;;
        pp-main) (cd "$inputs/mainc" && taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
        refine-sqlite) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 "$inputs/sqlite3.c" 2>&1 ;;
        refine-libc) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 /home/david/azp-bench/c-tokenizer/corpus/libc 2>&1 ;;
        refine-sqlite-after) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 --after-scalar 100 "$inputs/sqlite3.c" 2>&1 ;;
        refine-libc-after) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 --after-scalar 100 /home/david/azp-bench/c-tokenizer/corpus/libc 2>&1 ;;
    esac
    echo "== status $?"
done

#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r tree input switch <<< "$spec"
    echo "== round $round case $tree:$input:main$switch $(date +%T)"
    case "$input" in
        sqlite) BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$inputs/sqlite3.c" 2>&1 ;;
        main) (cd "$inputs/mainc" && BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
        *) BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$root/review-inputs/$input.c" 2>&1 ;;
    esac
    echo "== status $?"
done

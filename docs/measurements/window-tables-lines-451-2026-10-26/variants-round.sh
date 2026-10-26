#!/usr/bin/env bash
compiler="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r input variant switch <<< "$spec"
    extra=()
    [ "$variant" = whole ] && extra=(--window-bytes 2000000000)
    echo "== round $round case $spec $(date +%T)"
    if [ "$input" = sqlite ]; then
        BUSTER_451_VARIANT=$switch taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "$inputs/sqlite3.c" 2>&1
    else
        (cd "$inputs/mainc" && BUSTER_451_VARIANT=$switch taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "${extra[@]}" -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1)
    fi
    echo "== status $?"
done

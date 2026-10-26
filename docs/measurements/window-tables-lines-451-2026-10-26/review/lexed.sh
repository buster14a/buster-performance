#!/usr/bin/env bash
# #451 review: the bytes each screening build's windows lex (subphases.py's "W lexed bytes", per pass) against the
# windowed files' bytes ("W file bytes"), a window at a time (the default 128 KB), on #408's frozen sqlite3.c and main.c
# and on generate451's sources. Counts, not times: run on the laptop, at nice 19.
cd "$(dirname "$0")/.." || exit 1
root="$(pwd)"
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
for tree in "$@"; do
    for input in sqlite main long-lines spliced; do
        case "$input" in
            sqlite) out=$(nice -n 19 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$root/inputs/sqlite3.c" 2>&1) ;;
            main) out=$(cd "$root/inputs/mainc" && nice -n 19 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
            *) out=$(nice -n 19 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$root/inputs/$input.c" 2>&1) ;;
        esac
        printf "%s %s: " "$tree" "$input"
        echo "$out" | awk '/W lexed bytes/ {lexed = $8} /W file bytes/ {file = $8} END {printf "lexed %d of %d bytes\n", lexed, file}'
    done
done

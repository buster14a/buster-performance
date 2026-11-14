#!/usr/bin/env bash
# One round: ROUND SIDE... Each side's -c sqlite3.c and -fsyntax-only of the checker's unit on CPU 2, with perf stat's
# user instructions and cycles, a line each in results.tsv: round, side, workload, instructions, cycles.
set -euo pipefail
d=~/buster-fast-bench/2624-claude
round=$1
shift
unset CPATH C_INCLUDE_PATH
# sqlite3.c's -c with the 9700X job's measure-compile options.
source=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$source" "$source/sqlite3.c" -o "$d/sqlite3.o")
checker=(-fsyntax-only -march=znver5 "-I$d/base/src" -fwrapv -funsigned-char -fno-strict-aliasing --predefines "$d/predefines.h" "$d/base/src/buster/compiler/main_unit_checker.c")
for side in "$@"; do
    for workload in sqlite checker; do
        if [ "$workload" = sqlite ]; then args=("${sqlite[@]}"); else args=("${checker[@]}"); fi
        perf stat -x, -e instructions:u,cycles:u -o "$d/stat.txt" -- taskset -c 2 "$d/compiler-$side" "${args[@]}" > /dev/null
        printf '%s\t%s\t%s\t%s\t%s\n' "$round" "$side" "$workload" "$(awk -F, '/instructions/ { print $1 }' "$d/stat.txt")" \
            "$(awk -F, '/cycles/ { print $1 }' "$d/stat.txt")" >> "${RESULTS:-$d/results.tsv}"
    done
done

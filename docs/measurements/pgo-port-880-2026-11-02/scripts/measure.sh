#!/usr/bin/env bash
# measure.sh NAME=EXECUTABLE...: counts sqlite3.c's -fsyntax-only and -c and the 139 musl units' -c on CPU 2.
set -euo pipefail
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
mapfile -t MF < "$HOME/buster-fast-bench/claude-880/musl-corpus-139.txt"
MUSL=(-march=znver5 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
      -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include"
      "${MF[@]/#/$C/libc/musl/}")
for pair in "$@"; do
    v=${pair%%=*}; B=$(realpath "${pair#*=}")
    for mode in syntax sqlite-c musl-c; do
        case $mode in
            syntax) a=(-fsyntax-only "${BASE[@]}" "$C/sqlite/sqlite3.c") ;;
            sqlite-c) a=(-c -o "$T/sqlite.o" "${BASE[@]}" "$C/sqlite/sqlite3.c") ;;
            musl-c) a=(-c "${MUSL[@]}") ;;
        esac
        for run in 1 2 3; do
            (cd "$T" && taskset -c 2 perf stat -x, -e instructions:u,cycles:u,ex_ret_near_ret:u,ex_ret_brn_tkn:u "$B" "${a[@]}" 2>&1 > /dev/null) | awk -F, -v v="$v" -v m="$mode" -v r=$run '$3 ~ /:u$/ {printf "%s %s %s %s %s\n", v, m, r, $3, $1}'
        done
    done
done

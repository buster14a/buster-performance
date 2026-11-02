#!/usr/bin/env bash
# time-runs of main, head and head with BUSTER_PGO over 4 placements and 2 copies: -c sqlite3.c and -c of 139 musl units.
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
W=$R/timeruns
rm -rf "$W"; mkdir -p "$W/copies" "$W/out"
cd "$W/out"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
SQLITE=(-c --predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite" -o "$W/out/sqlite.o" "$C/sqlite/sqlite3.c")
mapfile -t MF < "$R/musl-corpus-139.txt"
MUSL=(-c -march=znver5 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
      -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include"
      "${MF[@]/#/$C/libc/musl/}")
BUILDS=()
for v in main head headpgo; do
    for p in 0 256 512 768; do BUILDS+=(--build "$v" "$R/shifts/$v/compiler-$p"); done
done
taskset -c 2 "$R/shifts/main/compiler-0" time-runs --runs 11 --warmups 1 --copies 2 --directory "$W/copies" "${BUILDS[@]}" --list "${SQLITE[@]}" --list "${MUSL[@]}"

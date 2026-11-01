#!/usr/bin/env bash
# time-runs over 5 builds × 4 placements × 2 copies × 2 lists.
set -euo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
W="$ROOT/work"
mkdir -p "$W/copies" "$W/timeruns-out"
cd "$W/musl-out"
rm -f ./*.o "$W/timeruns-out/sqlite.o"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE_ARGS=(-c --predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite" -o "$W/timeruns-out/sqlite.o" "$C/sqlite/sqlite3.c")
mapfile -t MF < /tmp/musl-corpus-139.txt
MUSL_ARGS=(-c -march=znver5 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
      -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include"
      "${MF[@]/#/$C/libc/musl/}")
BUILDS=()
for v in base pgo pgo-split fsec order; do
    for p in 0 256 512 768; do BUILDS+=(--build "$v" "$W/build/$v/compiler-$p"); done
done
"$W/build/base/compiler-0" time-runs --runs 11 --warmups 1 --copies 2 --directory "$W/copies" \
    "${BUILDS[@]}" --list "${BASE_ARGS[@]}" --list "${MUSL_ARGS[@]}"

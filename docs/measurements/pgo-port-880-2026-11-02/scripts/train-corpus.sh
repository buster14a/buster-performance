#!/usr/bin/env bash
# BUSTER_PGO_TRAIN script: the frozen corpus's training of buster-performance#182 (sqlite3.c in three modes, musl's
# units -fsyntax-only, 320 of them -c, c-testsuite's single-exec programs -c), with this laptop's copies.
set -uo pipefail
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
CT=$HOME/buster-fast-bench/codex-lowering-129/inputs/c-testsuite/tests/single-exec
BIN="$BUSTER_PGO_COMPILER"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
MUSL_INC=(-I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include")
MUSL_FLAGS=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -fno-color-diagnostics -fno-caret-diagnostics
      -ferror-limit=1 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700)
taskset -c 2 "$BIN" -E -P "${BASE[@]}" -o /dev/null "$C/sqlite/sqlite3.c"
"$BIN" -fsyntax-only "${BASE[@]}" "$C/sqlite/sqlite3.c"
"$BIN" -c "${BASE[@]}" -o sqlite.o "$C/sqlite/sqlite3.c"
mapfile -t musl_files < <(cd "$C/libc/musl" && find . -name '*.c' -type f | sort)
i=0
while [ $i -lt ${#musl_files[@]} ]; do
    chunk=("${musl_files[@]:$i:200}")
    ( cd "$C/libc/musl" && "$BIN" -fsyntax-only "${MUSL_FLAGS[@]}" "${MUSL_INC[@]}" "${chunk[@]}" ) > /dev/null 2>&1
    i=$((i + 200))
done
i=0
while [ $i -lt 320 ]; do
    chunk=("${musl_files[@]:$i:40}")
    "$BIN" -c "${MUSL_FLAGS[@]}" "${MUSL_INC[@]}" "${chunk[@]/#/$C/libc/musl/}" > /dev/null 2>&1
    rm -f ./*.o
    i=$((i + 40))
done
mapfile -t ct_files < <(find "$CT" -name '*.c' -type f | sort)
i=0
while [ $i -lt ${#ct_files[@]} ]; do
    "$BIN" -c -march=znver5 -std=gnu17 "${ct_files[@]:$i:55}" > /dev/null 2>&1
    rm -f ./*.o
    i=$((i + 55))
done
exit 0

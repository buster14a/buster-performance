#!/usr/bin/env bash
# Trains the instrumented build on the frozen corpora; writes profraw files under work/train.
set -uo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
CT=$HOME/buster-fast-bench/codex-lowering-129/inputs/c-testsuite/tests/single-exec
BIN="$ROOT/work/build/instr/compiler-0"
TRAIN="$ROOT/work/train"
mkdir -p "$TRAIN" "$ROOT/work/train-obj"
cd "$ROOT/work/train-obj"
export LLVM_PROFILE_FILE="$TRAIN/%p.profraw"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
MUSL_INC=(-I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include")
MUSL_FLAGS=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -fno-color-diagnostics -fno-caret-diagnostics
      -ferror-limit=1 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700)

echo "== sqlite3 three modes"
taskset -c 2 "$BIN" -E -P "${BASE[@]}" -o /dev/null "$C/sqlite/sqlite3.c"
taskset -c 2 "$BIN" -fsyntax-only "${BASE[@]}" "$C/sqlite/sqlite3.c"
taskset -c 2 "$BIN" -c "${BASE[@]}" -o "$ROOT/work/train-obj/sqlite.o" "$C/sqlite/sqlite3.c"
echo "== musl -fsyntax-only (all .c, chunks of 200)"
mapfile -t musl_files < <(cd "$C/libc/musl" && find . -name '*.c' -type f | sort)
echo "musl .c files: ${#musl_files[@]}"
i=0
while [ $i -lt ${#musl_files[@]} ]; do
    chunk=("${musl_files[@]:$i:200}")
    ( cd "$C/libc/musl" && "$BIN" -fsyntax-only "${MUSL_FLAGS[@]}" "${MUSL_INC[@]}" "${chunk[@]}" ) > /dev/null 2>&1
    i=$((i + 200))
done
echo "== musl -c (first 320, chunks of 40, cwd objects)"
i=0
n=0
while [ $i -lt ${#musl_files[@]} ] && [ $n -lt 320 ]; do
    chunk=("${musl_files[@]:$i:40}")
    ( cd "$ROOT/work/train-obj" && "$BIN" -c "${MUSL_FLAGS[@]}" "${MUSL_INC[@]}" "${chunk[@]/#/$C/libc/musl/}" ) > /dev/null 2>&1
    rm -f "$ROOT/work/train-obj"/*.o
    i=$((i + 40)); n=$((n + 40))
done
echo "== c-testsuite -c (chunks of 55)"
mapfile -t ct_files < <(find "$CT" -name '*.c' -type f | sort)
echo "c-testsuite .c files: ${#ct_files[@]}"
i=0
while [ $i -lt ${#ct_files[@]} ]; do
    chunk=("${ct_files[@]:$i:55}")
    ( cd "$ROOT/work/train-obj" && "$BIN" -c -march=znver5 -std=gnu17 "${chunk[@]}" ) > /dev/null 2>&1
    rm -f "$ROOT/work/train-obj"/*.o
    i=$((i + 55))
done
ls "$TRAIN"/*.profraw | wc -l

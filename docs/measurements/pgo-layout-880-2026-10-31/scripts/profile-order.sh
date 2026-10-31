#!/usr/bin/env bash
# Records a cycle profile of the base build over corpus compiles, then emits a symbol ordering file.
set -euo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
BIN="$ROOT/work/build/base/compiler-0"
W="$ROOT/work/order"
mkdir -p "$W"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
MUSL_INC=(-I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include")
MUSL_FLAGS=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -fno-color-diagnostics -fno-caret-diagnostics
      -ferror-limit=1 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700)
mapfile -t musl_files < <(cd "$C/libc/musl" && find . -name '*.c' -type f | sort | head -240)
taskset -c 2 perf record -q -e cycles:u -F 997 -o "$W/order.data" -- bash -c '
    set -u
    for i in 0 1 2 3 4 5 6 7 8 9 10 11; do
        "'"$BIN"'" -c "$@" -o /tmp/order-sqlite.o >/dev/null 2>&1 || exit 1
    done
    "'"$BIN"'" -fsyntax-only "$@" >/dev/null 2>&1 || exit 1
    ( cd '"$C"'/libc/musl && "'"$BIN"'" -fsyntax-only '"${MUSL_FLAGS[*]}"' '"${MUSL_INC[*]}"' ${musl_files[@]@Q} ) >/dev/null 2>&1 || true
' run "${BASE[@]}" "$C/sqlite/sqlite3.c"
perf report --stdio --no-children --dsos compiler-0 -i "$W/order.data" --percent-limit 0 > "$W/report.txt"
awk '/^#/ {next} NF==0 {next} /Event count/ {next} /^ *[0-9]+\.[0-9]+%/ {
    line=$0; sub(/^ *[0-9.]+% */,"",line); sub(/ *\[[^]]*\] */," ",line);
    # fields after stripping percent: then " symname  [dso]"
    n=split(line,a," "); print a[1]
}' "$W/report.txt" | awk 'NF' | head -40

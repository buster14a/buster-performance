#!/bin/bash
# run.sh COMPILER OUT.tsv: every corpus unit's dependency rule by both paths, sorted.
set -uo pipefail
P=$(realpath "$1"); out=$(realpath -m "$2")
here=$(cd "$(dirname "$0")" && pwd)
B=/home/user/buster; C=/home/user/corpora; L=/home/user/corpora/lua/src; M=$C/libc/musl
tmp=$(mktemp)
{
  cd "$B" && git ls-files 'tests/*.c' 'tests/**/*.c' | sed "s|^|$B/|" | xargs -P 4 -n 1 "$here/one.sh" "$P" tests
  ls "$B"/build/c-testsuite/tests/single-exec/*.c | xargs -P 4 -n 1 "$here/one.sh" "$P" c-testsuite
  ls "$L"/*.c | xargs -P 4 -n 1 "$here/one.sh" "$P" lua
  mflags=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
  ls "$M"/src/*/*.c "$M"/src/*/x86_64/*.c | xargs -P 4 -I{} "$here/one.sh" "$P" musl {} "${mflags[@]}"
  ls "$M"/src/*/*.c "$M"/src/*/x86_64/*.c | xargs -P 4 -I{} "$here/one.sh" "$P" musl-gnu99 {} "${mflags[@]}" -std=gnu99
  sflags=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
  "$here/one.sh" "$P" sqlite "$C/sqlite/sqlite3.c" "${sflags[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite"
  "$here/one.sh" "$P" sqlite "$C/sqlite/shell.c" "${sflags[@]}" "-I$C/sqlite"
  "$here/one.sh" "$P" sqlite-host "$C/sqlite/sqlite3.c" "-I$C/sqlite"
  "$here/one.sh" "$P" sqlite-host "$C/sqlite/shell.c" "-I$C/sqlite"
  for fl in -fno-pic -funsigned-char -fno-asynchronous-unwind-tables -O2 -DSQLITE_DEBUG -w -std=c23 -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_THREADSAFE=0; do
    "$here/one.sh" "$P" "sqlite[$fl]" "$C/sqlite/sqlite3.c" "$fl" "-I$C/sqlite"
  done
} > "$tmp"
sort "$tmp" > "$out"; rm -f "$tmp"
awk -F"\t" '{n[$1" "$2" "$4" "$7]++} END{for(k in n) print k, n[k]}' "$out" | sort

#!/bin/bash
# Usage: objects.sh BINARY OUT: -c of every unit of sqlite3.c, Lua 5.4.8, musl, main.c, c-testsuite's subset and
# tests/**/*.c with BINARY, each object's SHA-256 (or the exit status and the stderr's) into OUT/objects.txt (buster#3394).
set -u
BIN=$1; OUT=$2
mkdir -p $OUT/o
C=/home/user/corpus
R=/home/user/buster
SQ="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
M=$C/libc/musl
MUSL="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I$M/arch/x86_64 -I$M/arch/generic -I$C/musl-generated/obj/src/internal -I$M/src/include -I$M/src/internal -I$C/musl-generated/obj/include -I$M/include"
LUA="-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX $SQ"
{
  echo "sqlite|$SQ|$C/sqlite/sqlite3.c"
  for f in /home/user/inputs/lua-5.4.8/src/*.c; do echo "lua|$LUA|$f"; done
  for f in $(cd $M && ls src/*/*.c src/*/x86_64/*.c src/malloc/mallocng/*.c crt/*.c ldso/*.c 2>/dev/null); do echo "musl|$MUSL|$M/$f"; done
  echo "main|-march=native -I$R/src -fwrapv -funsigned-char|$R/src/buster/compiler/main.c"
  for n in $(sed -n 's|^\([0-9][0-9]*\)$|\1|p' $R/tests/c-testsuite/subset.txt); do echo "cts||$R/build/c-testsuite/tests/single-exec/$n.c"; done
  for f in $(cd $R && find tests -name "*.c" | sort); do echo "tests|-I$R/src -march=native|$R/$f"; done
} > $OUT/units.txt
one() {
  IFS='|' read -r set flags file <<< "$1"
  name=$(echo "$set:$file" | sha256sum | cut -c1-16)
  $BIN -c $flags "$file" -o $OUT/o/$name.o 2> $OUT/o/$name.err
  status=$?
  if [ $status -eq 0 ]; then echo "$set $file $(sha256sum < $OUT/o/$name.o | cut -c1-64)"; else echo "$set $file FAIL $status $(sha256sum < $OUT/o/$name.err | cut -c1-16)"; fi
  rm -f $OUT/o/$name.o
}
export -f one; export BIN OUT
tr '\n' '\0' < $OUT/units.txt | xargs -0 -P 4 -I{} bash -c 'one "$@"' _ {} | sort > $OUT/objects.txt
wc -l < $OUT/objects.txt; grep -c FAIL $OUT/objects.txt

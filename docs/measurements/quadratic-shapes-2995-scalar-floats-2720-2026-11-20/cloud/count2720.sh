#!/bin/bash
# count2720.sh OUT: --tier1 -c objects of sqlite3.c, speedtest1.c, Lua's sources and musl's units by base and head;
# per object, scalar floating instructions and .text bytes; prints totals and differing objects.
S=/tmp/claude-0/-home-user/1608c2dd-8533-51a5-ac4d-b0551c4ee67a/scratchpad
OUT=$1; mkdir -p $OUT/b $OUT/h
corpus=/home/user/corpus; musl=$corpus/libc/musl
SQ="--predefines $corpus/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
MU="-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
export SOURCE_DATE_EPOCH=1792454400
FP='\b(v?(add|sub|mul|div)s[sd]|v?u?comis[sd]|v?cvtt?s[sd]2u?si|v?cvtu?si2s[sd]|v?cvts[sd]2s[sd])\b'
one() { # name flags file
  for side in b h; do C=$S/compiler-base; [ $side = h ] && C=$S/compiler-2720
    $C --tier1 -c -w $2 "$3" -o $OUT/$side/$1.o 2> $OUT/$side/$1.err || echo "FAIL $side $1"
  done
  fb=$(objdump -d --no-show-raw-insn $OUT/b/$1.o 2>/dev/null | grep -cE "$FP"); fh=$(objdump -d --no-show-raw-insn $OUT/h/$1.o 2>/dev/null | grep -cE "$FP")
  tb=$(size -A $OUT/b/$1.o 2>/dev/null | awk '$1==".text"{print $2}'); th=$(size -A $OUT/h/$1.o 2>/dev/null | awk '$1==".text"{print $2}')
  same=1; cmp -s $OUT/b/$1.o $OUT/h/$1.o || same=0
  echo -e "$1\t$fb\t$fh\t$tb\t$th\t$same"
}
one sqlite3 "$SQ" $corpus/sqlite/sqlite3.c
one speedtest1 "$SQ -I $corpus/sqlite" /home/user/inputs/speedtest1.c
for f in /home/user/inputs/lua-5.4.8/src/*.c; do one lua_$(basename $f .c) "-O2 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX" $f; done
for f in $musl/src/*/*.c $musl/src/*/x86_64/*.c; do one musl_$(echo ${f#$musl/src/} | tr / _ | sed 's/\.c$//') "$MU" $f; done

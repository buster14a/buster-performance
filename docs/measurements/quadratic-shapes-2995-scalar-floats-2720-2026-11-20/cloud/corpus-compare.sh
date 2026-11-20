#!/bin/bash
# corpus-compare.sh OLD NEW OUTDIR: objects and stderr of sqlite3.c, musl's units and main.c, -c -Wall -Wextra
OLD=$1; NEW=$2; OUT=$3; mkdir -p $OUT/o $OUT/n
corpus=/home/user/corpus; musl=$corpus/libc/musl
SQ="--predefines $corpus/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
MU="-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
export SOURCE_DATE_EPOCH=1792454400
diffs=0; n=0
run() { # name flags file
  for side in o n; do C=$OLD; [ $side = n ] && C=$NEW; $C $2 -c -Wall -Wextra "$3" -o $OUT/$side/$1.o > $OUT/$side/$1.err 2>&1; echo $? >> $OUT/$side/$1.err; done
  n=$((n+1)); if ! cmp -s $OUT/o/$1.err $OUT/n/$1.err || ! cmp -s $OUT/o/$1.o $OUT/n/$1.o; then echo "DIFF $1"; diffs=$((diffs+1)); fi
}
run sqlite3 "$SQ" $corpus/sqlite/sqlite3.c
run main "-march=native -I/home/user/buster/src -fwrapv -funsigned-char" /home/user/buster/src/buster/compiler/main.c
for f in $musl/src/*/*.c $musl/src/*/x86_64/*.c; do name=$(echo ${f#$musl/src/} | tr / _); run "$name" "$MU" $f; done
echo "units=$n diffs=$diffs"

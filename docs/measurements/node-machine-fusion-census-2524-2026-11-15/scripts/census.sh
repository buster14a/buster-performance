#!/bin/bash
# census.sh COMPILER CORPORA: the shadow (--passes 0: it compares, it doesn't time) with its fused sweep's census on
# sqlite3.c, Lua 5.4.8's sources and musl's units (the corpora.sh set: one file a basename, src/*/*.c then
# src/*/x86_64/*.c), from CORPORA (sqlite/, lua-5.4.8/src/, libc/musl/, musl-generated/), into census/*.txt.
set -u
compiler=$1
c=$2
mkdir -p census
musl=$c/libc/musl
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl-generated/obj/include" -I "$musl/include")
"$compiler" measure-node-machine --shadow --passes 0 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite" "$c/sqlite/sqlite3.c" > census/sqlite3.txt 2>&1
"$compiler" measure-node-machine --shadow --passes 0 "$c"/lua-5.4.8/src/*.c > census/lua.txt 2>&1
"$compiler" measure-node-machine --shadow --passes 0 "${options[@]}" "${files[@]}" > census/musl.txt 2>&1

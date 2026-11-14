#!/bin/bash
# cloud-verify.sh COMPILER OUT: the shadow with --verify on sqlite3.c, Lua 5.4.8 and musl's units, without and with -g; one line
# a run with its differences and taken counts.
set -u
compiler=$1
out=$2
mkdir -p "$out"
corpus=$HOME/corpora
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$corpus/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
for g in "" "-g"; do
    s=${g:+-g}
    "$compiler" measure-node-machine --shadow --verify --passes 0 --list 20 $g -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" > "$out/verify-sqlite3$s.txt" 2>&1; echo "status $?" >> "$out/verify-sqlite3$s.txt" &
    "$compiler" measure-node-machine --shadow --verify --passes 0 --list 20 $g "$lua"/*.c > "$out/verify-lua$s.txt" 2>&1; echo "status $?" >> "$out/verify-lua$s.txt" &
    "$compiler" measure-node-machine --shadow --verify --passes 0 --list 20 $g "${mo[@]}" "${files[@]}" > "$out/verify-musl$s.txt" 2>&1; echo "status $?" >> "$out/verify-musl$s.txt" &
    wait
done
for f in "$out"/verify-*.txt; do echo "$(basename $f): $(grep -E 'differences|status' $f | tr '\n' ' ')"; done

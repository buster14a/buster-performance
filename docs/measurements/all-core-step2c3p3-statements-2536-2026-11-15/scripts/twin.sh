#!/bin/bash
# twin.sh EXE OUT: every unit by EXE's --selection-census -c and --scalar --selection-census -c; OUT/NAME.txt a line a unit:
# its path, whether the two statements lines are the same, and the vector path's line.
set -u
exe=$1 out=$2
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(echo "$f" | tr '/' '_')
    (cd "$directory" && "$exe" --selection-census --lanes 1 "$@" -c "$f" -o "$out/o/$b.v.o" 2> "$out/o/$b.v.err" < /dev/null)
    (cd "$directory" && "$exe" --selection-census --scalar --lanes 1 "$@" -c "$f" -o "$out/o/$b.s.o" 2> "$out/o/$b.s.err" < /dev/null)
    local v=$(grep -P '^selection-census-statements\t' "$out/o/$b.v.err")
    local s=$(grep -P '^selection-census-statements\t' "$out/o/$b.s.err")
    local verdict=different
    [ "$v" = "$s" ] && verdict=same
    printf '%s\t%s\t%s\n' "${f#/home/user/}" "$verdict" "$(echo "$v" | cut -f2- | tr '\t' ' ')"
    rm -f "$out/o/$b".*
}
export -f one
export exe out
run()
{
    local name=$1 directory=$2 files=$3
    shift 3
    xargs -P "$(nproc)" -I{} bash -c 'one "$@"' _ "$name" "$directory" {} "$@" < "$files" > "$out/$name.txt"
}
cp /home/user/.cache/claude-2536/step2c3p3/census/*.files "$out/"
run sqlite "$c/sqlite" "$out/sqlite.files" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite"
run lua "$c/lua/src" "$out/lua.files" -DLUA_USE_LINUX
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run musl "$musl" "$out/musl.files" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl/musl-generated/obj/include" -I "$musl/include"
run checker /home/user/buster "$out/checker.files"

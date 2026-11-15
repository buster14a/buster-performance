#!/bin/bash
# census.sh EXE OUT: every unit of every corpus by EXE's --selection-census -c; OUT/NAME.txt a line a unit: its name and
# its selection-census-builtins line's fields.
set -u
exe=$1 out=$2
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(basename "$f")
    (cd "$directory" && "$exe" --selection-census --lanes 1 "$@" -c "$f" -o "$out/o/$b.o" 2> "$out/o/$b.err" < /dev/null)
    printf '%s\t%s\n' "${f#/home/user/buster/}" "$(grep -P '^selection-census-builtins\t' "$out/o/$b.err" | cut -f2-)"
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
echo "$c/sqlite/sqlite3.c" > "$out/sqlite.files"
ls "$c/lua/src"/*.c > "$out/lua.files"
sed -n 's|^\([0-9][0-9]*\)$|/home/user/buster/build/c-testsuite/tests/single-exec/\1.c|p' /home/user/buster/tests/c-testsuite/subset.txt > "$out/ct.files"
echo /home/user/buster/src/buster/compiler/main.c > "$out/main.files"
cp /home/user/.cache/claude-2536/step2/census-walk-local/musl.files "$out/musl.files"
find /home/user/buster/tests/checker -name "*.c" | sort > "$out/checker.files"
run sqlite "$c/sqlite" "$out/sqlite.files" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite"
run lua "$c/lua/src" "$out/lua.files" -DLUA_USE_LINUX
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run musl "$musl" "$out/musl.files" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl/musl-generated/obj/include" -I "$musl/include"
run checker /home/user/buster "$out/checker.files"

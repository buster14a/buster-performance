#!/bin/bash
# provisional.sh COMPILER OUT: every unit of every corpus compiled by -c and by --provisional-selection -c; OUT/NAME.txt a
# line a unit: name, the provisional line's fields, and whether the objects are the same bytes.
set -u
compiler=$1 out=$2
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(basename "$f")
    (cd "$directory" && "$compiler" $VARIANT "$@" -c "$f" -o "$out/o/$b.e.o" 2> /dev/null < /dev/null; echo "$?" > "$out/o/$b.e.status")
    local line
    line=$(cd "$directory" && "$compiler" --provisional-selection $VARIANT "$@" -c "$f" -o "$out/o/$b.p.o" 2>&1 < /dev/null | grep '^provisional-selection' | tr '\t' ' ')
    local verdict=different
    cmp -s "$out/o/$b.e.o" "$out/o/$b.p.o" && verdict=same
    [ -f "$out/o/$b.e.o" ] || verdict=no-object
    printf '%s\t%s\t%s\n' "$(basename "$f")" "$line" "$verdict"
    rm -f "$out/o/$b.e.o" "$out/o/$b.p.o"
}
export -f one
export compiler out VARIANT
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
cp /home/user/.cache/claude-2536/step2/census-walk-local/musl.files "$out/musl.files" 2>/dev/null || cp /tmp/claude-0/-home-user/a5e3bb09-c72c-516b-a85a-e52d98746435/scratchpad/census/musl.files "$out/musl.files"
run sqlite "$c/sqlite" "$out/sqlite.files" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite"
run lua "$c/lua/src" "$out/lua.files" -DLUA_USE_LINUX
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run musl "$musl" "$out/musl.files" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl/musl-generated/obj/include" -I "$musl/include"

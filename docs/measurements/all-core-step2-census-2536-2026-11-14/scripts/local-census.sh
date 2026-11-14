#!/bin/bash
# census.sh COMPILER OUT: --selection-census's line for every unit of every corpus, OUT/NAME.txt (unit, then the line).
set -u
compiler=$1 out=$2
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local line
    line=$(cd "$directory" && "$compiler" --selection-census --lanes 1 "$@" -c "$f" -o "$out/o/$name.$(basename "$f").o" 2> "$out/o/$name.$(basename "$f").err" < /dev/null; grep '^selection-census' "$out/o/$name.$(basename "$f").err")
    printf '%s\t%s\n' "$(basename "$f")" "$line"
}
export -f one
export compiler out
run()
{
    local name=$1 directory=$2 files=$3
    shift 3
    xargs -P "$(nproc)" -I{} bash -c 'one "$@"' _ "$name" "$directory" {} "$@" < "$files" > "$out/$name.txt"
    cat "$out"/o/"$name".*.err | grep '^census-extra' > "$out/$name.extra"
}
echo "$c/sqlite/sqlite3.c" > "$out/sqlite.files"
ls "$c/lua/src"/*.c > "$out/lua.files"
sed -n 's|^\([0-9][0-9]*\)$|/home/user/buster/build/c-testsuite/tests/single-exec/\1.c|p' /home/user/buster/tests/c-testsuite/subset.txt > "$out/ct.files"
echo /home/user/buster/src/buster/compiler/main.c > "$out/main.files"
cp /tmp/claude-0/-home-user/a5e3bb09-c72c-516b-a85a-e52d98746435/scratchpad/census/musl.files "$out/musl.files"
run sqlite "$c/sqlite" "$out/sqlite.files" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite"
run lua "$c/lua/src" "$out/lua.files" -DLUA_USE_LINUX
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run musl "$musl" "$out/musl.files" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl/musl-generated/obj/include" -I "$musl/include"

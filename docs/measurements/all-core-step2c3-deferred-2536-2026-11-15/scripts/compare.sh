#!/bin/bash
# compare.sh BASE HEAD OUT [OPTIONS...]: every unit of every corpus compiled by BASE and HEAD with OPTIONS -c; OUT/NAME.txt
# a line a unit: name, whether the objects are the same bytes, whether stderr is the same text, both exit statuses.
set -u
base=$1 head=$2 out=$3
shift 3
export EXTRA="$*"
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(basename "$f")
    (cd "$directory" && "$base" --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.b.o" 2> "$out/o/$b.b.err" < /dev/null; echo $? > "$out/o/$b.b.status")
    (cd "$directory" && "$head" --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.h.o" 2> "$out/o/$b.h.err" < /dev/null; echo $? > "$out/o/$b.h.status")
    local objects=different errors=different
    cmp -s "$out/o/$b.b.o" "$out/o/$b.h.o" && objects=same
    [ -f "$out/o/$b.b.o" ] || [ -f "$out/o/$b.h.o" ] || objects=none
    cmp -s "$out/o/$b.b.err" "$out/o/$b.h.err" && errors=same
    printf '%s\t%s\t%s\t%s\t%s\n' "$(basename "$f")" "$objects" "$errors" "$(cat "$out/o/$b.b.status")" "$(cat "$out/o/$b.h.status")"
    rm -f "$out/o/$b".*
}
export -f one
export base head out
run()
{
    local name=$1 directory=$2 files=$3
    shift 3
    xargs -P "$(nproc)" -I{} bash -c 'one "$@"' _ "$name" "$directory" {} "$@" < "$files" > "$out/$name.txt"
}
s=/home/user/.cache/claude-2536/step2c/vector
echo "$c/sqlite/sqlite3.c" > "$out/sqlite.files"
ls "$c/lua/src"/*.c > "$out/lua.files"
sed -n 's|^\([0-9][0-9]*\)$|/home/user/buster/build/c-testsuite/tests/single-exec/\1.c|p' /home/user/buster/tests/c-testsuite/subset.txt > "$out/ct.files"
echo /home/user/buster/src/buster/compiler/main.c > "$out/main.files"
cp /home/user/.cache/claude-2536/step2/census-walk-local/musl.files "$out/musl.files"
run sqlite "$c/sqlite" "$out/sqlite.files" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$c/sqlite"
run lua "$c/lua/src" "$out/lua.files" -DLUA_USE_LINUX
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run musl "$musl" "$out/musl.files" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl/musl-generated/obj/include" -I "$musl/include"
find /home/user/buster/tests/checker -name "*.c" | sort > "$out/checker.files"
run checker /home/user/buster "$out/checker.files"

#!/bin/bash
# provisional.sh EXE OUT [OPTIONS...]: every unit of every corpus by EXE's -c and --provisional-selection -c with OPTIONS;
# OUT/NAME.txt a line a unit: its path, whether the objects are the same bytes (or both missing), both exit statuses, and
# the option's report.
set -u
exe=$1 out=$2
shift 2
export EXTRA="$*"
c=/home/user/.cache/claude-2536
musl=$c/musl/libc/musl
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(echo "$f" | tr '/' '_')
    (cd "$directory" && "$exe" --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.p.o" 2> /dev/null < /dev/null; echo $? > "$out/o/$b.p.status")
    (cd "$directory" && "$exe" --provisional-selection --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.v.o" 2> "$out/o/$b.v.err" < /dev/null; echo $? > "$out/o/$b.v.status")
    local objects=different
    cmp -s "$out/o/$b.p.o" "$out/o/$b.v.o" && objects=same
    [ -f "$out/o/$b.p.o" ] || [ -f "$out/o/$b.v.o" ] || objects=none
    printf '%s\t%s\t%s\t%s\t%s\n' "${f#/home/user/}" "$objects" "$(cat "$out/o/$b.p.status")" "$(cat "$out/o/$b.v.status")" "$(grep -P '^provisional-selection\t' "$out/o/$b.v.err" | tr '\t' ' ')"
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

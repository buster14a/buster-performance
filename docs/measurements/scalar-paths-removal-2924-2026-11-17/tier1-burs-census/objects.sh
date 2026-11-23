#!/bin/bash
# objects.sh EXE OUT: --tier1 -c objects of sqlite3.c, Lua 5.4.8 and musl's units by EXE (one lane), into OUT/{sqlite,lua,musl},
# with the caller's environment (the experiment's BUSTER_FRAME_* knobs); DUMPDIR set: each list dumps its frame requests to
# DUMPDIR/LIST.bin. ERR set: each compile's stderr appended to ERR-LIST. Prints each list's exit status. (From #2924's C7 gate.)
set -u
exe=$1; out=$2
corpus=/home/user/corpora
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
mkdir -p "$out/sqlite" "$out/lua" "$out/musl"
d() { echo "BUSTER_BURS_CENSUS=/tmp/claude-0/burs-c-$1.bin BUSTER_BURS_MUNCH=/tmp/claude-0/burs-m-$1.bin"; }
(cd "$out/sqlite" && env $(d sqlite) "$exe" -c --tier1 ${EXTRA:-} --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>>"${ERR:-/dev/null}${ERR:+-sqlite}"); echo "sqlite $?"
(cd "$out/lua" && env $(d lua) "$exe" -c --tier1 ${EXTRA:-} --lanes 1 "$lua"/*.c > /dev/null 2>>"${ERR:-/dev/null}${ERR:+-lua}"); echo "lua $?"
(cd "$out/musl" && env $(d musl) "$exe" -c --tier1 ${EXTRA:-} --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}" > /dev/null 2>>"${ERR:-/dev/null}${ERR:+-musl}"); echo "musl $?"

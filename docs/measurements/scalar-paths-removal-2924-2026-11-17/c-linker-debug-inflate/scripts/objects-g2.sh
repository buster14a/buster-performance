#!/bin/bash
# objects-g.sh EXE OUT MODE: -c -g objects of sqlite3.c, Lua 5.4.8 and musl's units by EXE, MODE default or scalar
# (--scalar), into OUT/{sqlite,lua,musl}; each list's exit status. After c-dominators-deletion/objects.sh, with -g. Every
# compile runs in one directory, /dev/shm/2924-linker/work, then its objects move to OUT: -g's DW_AT_comp_dir is the
# compile's directory, so that base's and head's objects differ only by what they compute.
set -u
exe=$1; out=$2; mode=$3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$HOME/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
flag=()
[ "$mode" = scalar ] && flag=(--scalar)
work=/dev/shm/2924-linker/work
rm -rf "$out" "$work"; mkdir -p "$work/sqlite" "$work/lua" "$work/musl"
(cd "$work/sqlite" && "$exe" "${flag[@]}" -g -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o); echo "sqlite $?"
(cd "$work/lua" && "$exe" "${flag[@]}" -g -c --lanes 1 "$lua"/*.c); echo "lua $?"
(cd "$work/musl" && "$exe" "${flag[@]}" -g -c --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}" > /dev/null 2>&1); echo "musl $?"
mv "$work" "$out"

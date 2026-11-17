#!/bin/bash
# objects.sh EXE OUT MODE: -c objects of sqlite3.c, Lua 5.4.8 and musl's units by EXE, MODE default or scalar (--scalar),
# into OUT/{sqlite,lua,musl}. Prints each list's exit status.
set -u
exe=$1; out=$2; mode=$3
D=$(cd "$(dirname "$0")" && pwd)
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
flag=()
[ "$mode" = scalar ] && flag=(--scalar)
mkdir -p "$out/sqlite" "$out/lua" "$out/musl"
(cd "$out/sqlite" && "$exe" "${flag[@]}" -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o); echo "sqlite $?"
(cd "$out/lua" && "$exe" "${flag[@]}" -c --lanes 1 "$lua"/*.c); echo "lua $?"
(cd "$out/musl" && "$exe" "${flag[@]}" -c --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}" > /dev/null 2>&1); echo "musl $?"

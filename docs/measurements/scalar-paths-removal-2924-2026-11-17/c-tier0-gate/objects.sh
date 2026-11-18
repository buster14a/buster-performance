#!/bin/bash
# objects.sh EXE OUT SRC: -c --verify objects of sqlite3.c, Lua 5.4.8, musl's units and buster's own main.c (SRC's, the
# unit Tier 0's inlining splices intrinsics into) by EXE on one lane, into OUT/{sqlite,lua,musl,buster}, with the
# caller's BUSTER_TIER0_SCALAR_AREAS and BUSTER_TIER0_AREA_TICKS. --verify runs the unwind analyzer. Prints each list's
# exit status.
set -u
exe=$1; out=$2; src=$3
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
mkdir -p "$out/sqlite" "$out/lua" "$out/musl" "$out/buster"
(cd "$out/sqlite" && "$exe" -c --verify --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>>"${ERR:-/dev/null}"); echo "sqlite $?"
(cd "$out/lua" && "$exe" -c --verify --lanes 1 "$lua"/*.c > /dev/null 2>>"${ERR:-/dev/null}"); echo "lua $?"
(cd "$out/musl" && "$exe" -c --verify --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}" > /dev/null 2>>"${ERR:-/dev/null}"); echo "musl $?"
(cd "$out/buster" && "$exe" -c --verify --lanes 1 -march=znver5 -I"$src/src" -fwrapv -funsigned-char -fno-strict-aliasing "$src/src/buster/compiler/main.c" -o main.o > /dev/null 2>>"${ERR:-/dev/null}"); echo "buster $?"

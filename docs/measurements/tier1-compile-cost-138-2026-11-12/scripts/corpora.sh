#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# corpora.sh: the three workloads, sourced by the other scripts. Sets, for NAME in sqlite, lua, musl:
#   NAME_options  the compile's options, without -c and the files
#   NAME_files    the sources
# sqlite: the frozen corpus's sqlite3.c with the 9700X job's compile_time options (one unit).
# lua: Lua 5.4.8's interpreter, lua.c and the library's 32 sources, as measure-tier1-programs builds them (33 units).
# musl: the frozen corpus's musl, the first source of each base name (one object a unit in one directory).
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
sqlite_files=("$sqlite/sqlite3.c")
lua=$here/inputs/lua-5.4.8/src
lua_options=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
lua_files=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump \
         lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files+=("$lua/$s.c")
done
musl=$corpus/libc/musl
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
musl_files=()
declare -A corpora_seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${corpora_seen[$b]:-} ]]; then corpora_seen[$b]=1; musl_files+=("$f"); fi
done

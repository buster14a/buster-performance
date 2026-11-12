#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# census.sh: measure-node-machine (#2524's step 0) on the frozen corpus's sqlite3.c (the 9700X job's compile_time
# options), Lua 5.4.8's 34 sources and musl's 1,336 units (the first source of each base name, as the one-core record's
# musl.sh took them), inside one hold of the lock: it counts, it doesn't time. Each run's report, with --list 40, and
# the inputs' hashes.
set -u
cd "$(dirname "$0")/.."
out=$PWD/results
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
compiler=$PWD/src/build/compiler
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
{
    sha256sum "$compiler" "$sqlite/sqlite3.c" "$lua"/*.c "$lua"/*.h
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > "$out/inputs.txt" 2>&1
./scripts/lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'
taskset -c 2 '$compiler' measure-node-machine --list 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/sqlite3.txt' 2>&1; echo \"status \$?\" >> '$out/sqlite3.txt'
taskset -c 2 '$compiler' measure-node-machine --list 40 '$lua'/*.c > '$out/lua.txt' 2>&1; echo \"status \$?\" >> '$out/lua.txt'
taskset -c 2 '$compiler' measure-node-machine --list 40 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I '$musl/arch/x86_64' -I '$musl/arch/generic' -I '$corpus/musl-generated/obj/src/internal' -I '$musl/src/include' -I '$musl/src/internal' -I '$corpus/musl-generated/obj/include' -I '$musl/include' ${files[*]} > '$out/musl.txt' 2>&1; echo \"status \$?\" >> '$out/musl.txt'
"
date -u +%FT%TZ > "$out/.done"

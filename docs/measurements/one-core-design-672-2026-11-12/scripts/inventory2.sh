#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# inventory2.sh: #1048's inventory with more categories counted as ordinary, for the share of bodies and of their nodes
# that a path taking those categories would take whole, inside one hold of the lock (counts, not times): the frozen
# sqlite3.c, and musl.sh's 1,336 units.
set -u
cd "$(dirname "$0")"
out=results/inventory
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder2.txt"
sq=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
run()
{
    local name=$1; shift
    taskset -c 2 "$compiler" measure-lowering-templates --top 1 --keys 1 --abstracts 1 "$@" > "$out/$name.txt" 2>&1 || echo "status $?" >> "$out/$name.txt"
}
run sqlite-allow3 --allow call --allow '&&-||-?:' --allow bit-field "${sq[@]}"
run sqlite-allow4 --allow call --allow '&&-||-?:' --allow bit-field --allow builtin-or-va_arg "${sq[@]}"
run musl-default "${mo[@]}" "${files[@]}"
run musl-allow2 --allow call --allow '&&-||-?:' "${mo[@]}" "${files[@]}"
run musl-allow3 --allow call --allow '&&-||-?:' --allow bit-field "${mo[@]}" "${files[@]}"
run musl-allow4 --allow call --allow '&&-||-?:' --allow bit-field --allow builtin-or-va_arg "${mo[@]}" "${files[@]}"
date -u +%FT%TZ > "$out/.done2"
exit $status

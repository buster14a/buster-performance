#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# census.sh: the units' preprocessed text, for a count of their tokens inside function bodies and outside
# (tools/census.py), inside one hold of the lock: the frozen sqlite3.c by -E, and musl.sh's 1,336 units by -E each.
set -u
cd "$(dirname "$0")"
out=$PWD/results/census
mkdir -p "$out" scratch
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
compiler=$PWD/src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
"$compiler" -E -P -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o scratch/sqlite3.i || status=1
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
: > scratch/musl.i
declare -A seen
units=0
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then
        seen[$b]=1
        printf '\n#pragma census_unit %s\n' "$b" >> scratch/musl.i
        "$compiler" -E -P "${options[@]}" "$f" >> scratch/musl.i 2> /dev/null || status=1
        units=$((units + 1))
    fi
done
echo "musl units $units" > "$out/units.txt"
wc -c scratch/sqlite3.i scratch/musl.i >> "$out/units.txt"
gzip -c scratch/sqlite3.i > "$out/sqlite3.i.gz"
gzip -c scratch/musl.i > "$out/musl.i.gz"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

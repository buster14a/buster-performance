#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prep.sh: the inputs every other script reads, made inside one hold of the lock by the clean tree's compiler:
#   scratch/musl-units.txt        musl's 1,336 units' paths
#   scratch/musl-i/NAME.i         each unit preprocessed (-E -P)
#   scratch/musl-e/NAME.i         each unit preprocessed with its line markers (-E), for the census by header
#   scratch/musl-spine/NAME.i     each unit without its function bodies (tools/units.py)
#   scratch/musl-empty/NAME.c     an empty unit per unit; scratch/musl-one/NAME.c one declaration per unit
#   scratch/sqlite3.i, sqlite3-spine.i   the frozen sqlite3.c preprocessed, and without its bodies (tools/spine.py)
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/prep
mkdir -p "$out" scratch/musl-i scratch/musl-e scratch/musl-spine scratch/musl-empty scratch/musl-one
compiler=$PWD/src/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
musl_units > scratch/musl-units.txt
wc -l < scratch/musl-units.txt > "$out/units.txt"
xargs cat < scratch/musl-units.txt | wc -c >> "$out/units.txt"
while read -r f; do
    b=${f##*/}; b=${b%.c}
    "$compiler" -E -P "${musl_options[@]}" "$f" -o "scratch/musl-i/$b.i" 2>> "$out/preprocess.log" || status=1
    "$compiler" -E "${musl_options[@]}" "$f" -o "scratch/musl-e/$b.i" 2>> "$out/preprocess.log" || status=1
    : > "scratch/musl-empty/$b.c"
    printf 'int unit_%s;\n' "$(printf %s "$b" | tr -c 'A-Za-z0-9_' _)" > "scratch/musl-one/$b.c"
done < scratch/musl-units.txt
python3 tools/units.py scratch/musl-i scratch/musl-spine "$out/musl-census.tsv" "$out/musl-declarations.tsv" > "$out/units.log" 2>&1 || status=1
"$compiler" -E -P "${sqlite_options[@]}" "$sqlite/sqlite3.c" -o scratch/sqlite3.i || status=1
python3 tools/spine.py scratch/sqlite3.i scratch/sqlite3-spine.i > "$out/sqlite-spine.txt" 2>&1 || status=1
mkdir -p scratch/sqlite-i scratch/sqlite-spine-out
cp scratch/sqlite3.i scratch/sqlite-i/sqlite3.i
python3 tools/units.py scratch/sqlite-i scratch/sqlite-spine-out "$out/sqlite-census.tsv" "$out/sqlite-declarations.tsv" >> "$out/units.log" 2>&1 || status=1
sha256sum scratch/sqlite3.i scratch/sqlite3-spine.i >> "$out/sqlite-spine.txt"
cat scratch/musl-i/*.i | sha256sum > "$out/musl-i.sha256"
cat scratch/musl-spine/*.i | sha256sum > "$out/musl-spine.sha256"
du -sb scratch/musl-i scratch/musl-e scratch/musl-spine >> "$out/units.txt"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

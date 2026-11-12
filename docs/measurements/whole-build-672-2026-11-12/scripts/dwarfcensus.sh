#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# dwarfcensus.sh: what the -g objects of sqlite3.c hold, by this compiler, clang -O0 and tcc -gdwarf: each debug
# section's bytes and relocations, the DIEs by tag, and llvm-dwarfdump --verify's verdict, inside one hold of the lock
# (lock.sh ./dwarfcensus.sh); it reads sqlite-g's and sqlite-g-refs' outputs.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/dwarfcensus
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
for name in b-cg clang-cg gcc-cg tcc-cgdwarf; do
    f=$t/o/$name.o
    if [[ -f $f ]]; then
        {
            echo "== sections (bytes)"
            size -A "$f" | awk '$1 ~ /debug|stab/ { print $1 "\t" $2 }'
            echo "== relocations by section"
            readelf -rW "$f" | awk '/^Relocation section/ { name = $3; gsub(/\x27/, "", name); count = $(NF - 1); print name "\t" count }' | grep -i debug
            echo "== DIEs by tag"
            llvm-dwarfdump --debug-info "$f" 2> /dev/null | grep -o 'DW_TAG_[a-z_]*' | sort | uniq -c | sort -rn
            echo "== location lists and range lists (entries)"
            llvm-dwarfdump --debug-loclists "$f" 2> /dev/null | grep -c 'DW_LLE_' || true
            llvm-dwarfdump --debug-rnglists "$f" 2> /dev/null | grep -c 'DW_RLE_' || true
            echo "== line table rows"
            llvm-dwarfdump --debug-line "$f" 2> /dev/null | grep -c '^0x[0-9a-f]\{16\}' || true
            echo "== verify"
            llvm-dwarfdump --verify "$f" > "$out/$name.verify.txt" 2>&1
            echo "status $?"
            tail -3 "$out/$name.verify.txt"
        } > "$out/$name.txt" 2>&1
    fi
done
date -u +%FT%TZ > "$out/.done"

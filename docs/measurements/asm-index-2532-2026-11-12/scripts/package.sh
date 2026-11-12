#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# package.sh OUT: the record's files from this directory into OUT: results/ as raw/, results-prelim/ as raw/prelim/,
# tables/ and tables-prelim/, the scripts, and the build logs without the lock's waiting lines (which name other
# sessions). Every run's diagnostics are listed by MD5 in raw/.../stderr.md5, and one copy of each distinct text kept;
# a text file over 32 KB is gzipped.
set -eu
cd "$(dirname "$0")"
out=$1
rm -rf "$out"
mkdir -p "$out/raw" "$out/scripts" "$out/tables"
cp -r results/. "$out/raw/"
mkdir -p "$out/raw/prelim"
cp -r results-prelim/. "$out/raw/prelim/"
cp tables/musl.tsv tables/sqlite.tsv tables/stages-lower.txt "$out/tables/" 2>/dev/null || true
mkdir -p "$out/tables/prelim"
cp tables-prelim/musl.tsv tables-prelim/sqlite.tsv "$out/tables/prelim/"
mv "$out/raw/env.txt" "$out/env.txt"
cp ./*.sh reduce.c "$out/scripts/"
for b in build-main build-head build-head2; do
    grep -v -E 'exclusive.sh: waiting for the 9700X|^  title: |^  link: ' "$b.log" > "$out/raw/$b.log"
done
for d in "$out/raw/musl" "$out/raw/prelim/musl" "$out/raw/sqlite" "$out/raw/prelim/sqlite"; do
    (cd "$d" && md5sum stderr-*.txt > stderr.md5)
    first=$(cd "$d" && ls stderr-*.txt | head -1)
    for f in "$d"/stderr-*.txt; do
        if [[ ${f##*/} != "$first" ]]; then rm "$f"; fi
    done
done
find "$out" -type f -size +32k \( -name '*.txt' -o -name '*.log' -o -name '*.tsv' \) -exec gzip -9n {} +

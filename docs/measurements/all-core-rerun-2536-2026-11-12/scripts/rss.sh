#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# rss.sh: why every cohort's peak RSS is about 4.5 MB above the first record's, with about 50 fewer faults, inside one
# hold of the lock. The executable here is a reflinked copy of the first record's (the same bytes, another inode and so
# another page cache). One worker on CPU 2, 6 compiles a cohort, alternating the first record's own file and this copy,
# two rounds, each run counted (common.sh's BASIC): the rows' peak_kb and minor_faults say whether the file is the
# difference.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=results/rss
mkdir -p "$out" scratch
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
original=$HOME/buster-fast-bench/672-allcore-claude/src/build/compiler
sha256sum "$original" "$compiler" > "$out/sha256.txt"
status=0
for round in 0 1; do
    for which in original copy; do
        binary=$compiler
        [[ $which == original ]] && binary=$original
        ./allcore cohort --cpus 2 --loops 6 --label "rss-$which.w1" --out "$out/$which.r$round.rows.tsv" --events "$EVENTS_BASIC" -- \
            "$binary" --lanes 1 -c "${SQLITE_OPTIONS[@]}" "$sqlite/sqlite3.c" -o "scratch/rss-$which.o" || status=1
    done
done
cmp scratch/rss-original.o scratch/rss-copy.o > "$out/objects.txt" 2>&1 && echo "objects identical" >> "$out/objects.txt"
exit $status

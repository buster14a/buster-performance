#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# sqlite.sh [ROUNDS]: -c of the frozen corpus's sqlite3.c (the 9700X job's compile_time options), main against head,
# inside one hold of the lock, CPU 2: ROUNDS rounds (default 11) of each way under perf stat in alternating order, with
# the address space's randomization off (setarch -R), then the two objects compared. sqlite3.c has no asm statement.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-11}
out=$PWD/results/sqlite
mkdir -p "$out" scratch/sqlite-main scratch/sqlite-head
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
: > "$out/status.txt"
for ((r = 1; r <= rounds; r += 1)); do
    if ((r % 2)); then order=(main head); else order=(head main); fi
    for w in "${order[@]}"; do
        (cd "scratch/sqlite-$w" && taskset -c 2 perf stat -x, -o "$out/stat-$w-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- setarch "$(uname -m)" -R "$(compiler_of "$w")" "${sqlite_options[@]}" -c "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2> "$out/stderr-$w-$r.txt"; echo "$w $r status $?" >> "$out/status.txt")
    done
done
if cmp -s scratch/sqlite-main/sqlite3.o scratch/sqlite-head/sqlite3.o; then echo "sqlite3.o: the same bytes ($(stat -c %s scratch/sqlite-main/sqlite3.o) bytes)"; else echo "sqlite3.o: DIFFERENT"; fi > "$out/objects.txt"
sha256sum scratch/sqlite-main/sqlite3.o scratch/sqlite-head/sqlite3.o >> "$out/objects.txt"
rm -rf scratch/sqlite-main scratch/sqlite-head
date -u +%FT%TZ > "$out/.done"

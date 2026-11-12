#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# spine.sh [RUNS]: each stage's time for the frozen sqlite3.c's file scope alone, inside one hold of the lock. The
# unit preprocessed (census.sh's scratch/sqlite3.i) is compiled whole and without its function bodies
# (tools/spine.py), RUNS times each (default 11), alternating, pinned to CPU 2, with --time-stages: -fsyntax-only for
# both, and -c for the whole unit. The difference is the bodies' share of each stage.
set -u
cd "$(dirname "$0")"
runs=${1:-11}
out=results/spine
mkdir -p "$out" scratch
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
python3 tools/spine.py scratch/sqlite3.i scratch/sqlite3-spine.i > "$out/spine.txt" 2>&1 || status=1
sha256sum scratch/sqlite3.i scratch/sqlite3-spine.i >> "$out/spine.txt"
for ((r = 1; r <= runs; r += 1)); do
    taskset -c 2 "$compiler" --time-stages -fsyntax-only scratch/sqlite3.i > /dev/null 2> "$out/whole-syntax-$r.txt"; echo "status $?" >> "$out/whole-syntax-$r.txt"
    taskset -c 2 "$compiler" --time-stages -fsyntax-only scratch/sqlite3-spine.i > /dev/null 2> "$out/spine-syntax-$r.txt"; echo "status $?" >> "$out/spine-syntax-$r.txt"
    taskset -c 2 "$compiler" --time-stages -c scratch/sqlite3.i -o scratch/sqlite3-i.o > /dev/null 2> "$out/whole-c-$r.txt"; echo "status $?" >> "$out/whole-c-$r.txt"
    taskset -c 2 "$compiler" --time-stages -c scratch/sqlite3-spine.i -o scratch/sqlite3-spine.o > /dev/null 2> "$out/spine-c-$r.txt"; echo "status $?" >> "$out/spine-c-$r.txt"
done
taskset -c 2 perf stat -x, -r 5 -o "$out/stat-whole-syntax.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" -fsyntax-only scratch/sqlite3.i > /dev/null 2>&1
taskset -c 2 perf stat -x, -r 5 -o "$out/stat-spine-syntax.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" -fsyntax-only scratch/sqlite3-spine.i > /dev/null 2>&1
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

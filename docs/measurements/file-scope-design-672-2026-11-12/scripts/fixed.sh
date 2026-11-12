#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# fixed.sh: a unit's fixed costs, inside one hold of the lock, CPU 2: an empty unit and a unit of one declaration as
# a process each (`-c`, 200 runs under perf stat -r), and N empty units as one command for N = 1, 16, 256, 1,336 and
# 4,096 (5 runs each), which says what of the fixed cost is the process's and what each unit's.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/fixed
here=$PWD
mkdir -p "$out" scratch/fixed scratch/objects-fixed
compiler=$PWD/src/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
for ((i = 0; i < 4096; i += 1)); do : > "scratch/fixed/e$i.c"; done
printf 'int one;\n' > scratch/fixed/one.c
cd scratch/objects-fixed || exit 1
events='{cycles:u,instructions:u,cycles:k,instructions:k}'
taskset -c 2 perf stat -x, -r 200 -o "$out/stat-process-empty-1.csv" -e "$events" -e task-clock,page-faults -- "$compiler" -c "$here/scratch/fixed/e0.c" -o e0.o > /dev/null 2>&1
taskset -c 2 perf stat -x, -r 200 -o "$out/stat-process-one-1.csv" -e "$events" -e task-clock,page-faults -- "$compiler" -c "$here/scratch/fixed/one.c" -o one.o > /dev/null 2>&1
taskset -c 2 perf stat -x, -r 200 -o "$out/stat-process-syntax-empty-1.csv" -e "$events" -e task-clock,page-faults -- "$compiler" -fsyntax-only "$here/scratch/fixed/e0.c" > /dev/null 2>&1
for n in 1 16 256 1336 4096; do
    units=()
    for ((i = 0; i < n; i += 1)); do units+=("$here/scratch/fixed/e$i.c"); done
    for r in 1 2 3 4 5; do
        taskset -c 2 perf stat -x, -o "$out/stat-units-$n-$r.csv" -e "$events" -e task-clock,page-faults -- "$compiler" --lanes 1 -c "${units[@]}" > /dev/null 2>&1
    done
done
cd "$here" && rm -rf scratch/objects-fixed scratch/fixed
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
date -u +%FT%TZ > "$out/.done"

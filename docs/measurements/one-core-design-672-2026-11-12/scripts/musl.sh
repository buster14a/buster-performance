#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# musl.sh: the frozen corpus's musl sources as one command on one lane, pinned to CPU 2, inside one hold of the lock:
# -c with --time-stages (3 runs, the objects in a scratch directory), for the stages of a header-dominated, many-unit
# workload beside sqlite3.c's.
set -u
cd "$(dirname "$0")"
out=$PWD/results/musl
mkdir -p "$out" scratch/musl-objects
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
compiler=$PWD/src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
cd scratch/musl-objects || exit 1
# One object a unit in one directory: the first source of each base name (two units of one name would write one object).
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
echo "units ${#files[@]}" > "$out/units.txt"
cat "${files[@]}" | wc -c >> "$out/units.txt"
for r in 1 2 3; do
    taskset -c 2 "$compiler" "${options[@]}" --lanes 1 -c --time-stages "${files[@]}" > "$out/c-$r.stdout.txt" 2> "$out/c-$r.stages.txt"
    echo "status $?" >> "$out/c-$r.stages.txt"
done
taskset -c 2 perf stat -x, -r 3 -o "$out/stat-c.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- \
    "$compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1
ls | wc -l >> "$out/units.txt"
cd .. && rm -rf musl-objects
date -u +%FT%TZ > "$out/.done"
exit $status

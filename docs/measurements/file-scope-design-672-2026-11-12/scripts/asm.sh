#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# asm.sh [ROUNDS]: what the asm matcher's index costs musl's command, inside one hold of the lock: the patched build
# (probe.patch) makes the index once a process with BUSTER_PROBE_ASM_CACHE set, and once a unit with asm statements
# without it, as main does. ROUNDS rounds (default 5) of `-c` of the sources each way under perf stat, CPU 2, the
# probe's stages each way, and every object compared.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/asm
mkdir -p "$out" scratch/objects-asm-a scratch/objects-asm-b
probe=$PWD/src-probe/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
names=("${sources[@]##*/}"); names=("${names[@]%.c}")
: > "$out/status.txt"
for ((r = 1; r <= rounds; r += 1)); do
    (cd scratch/objects-asm-a && taskset -c 2 perf stat -x, -o "$out/stat-each-unit-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1; echo "each-unit $r status $?" >> "$out/status.txt")
    (cd scratch/objects-asm-b && BUSTER_PROBE_ASM_CACHE=1 taskset -c 2 perf stat -x, -o "$out/stat-once-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1; echo "once $r status $?" >> "$out/status.txt")
done
same=0; different=0
for n in "${names[@]}"; do
    if cmp -s "scratch/objects-asm-a/$n.o" "scratch/objects-asm-b/$n.o"; then same=$((same + 1)); else different=$((different + 1)); fi
done
echo "objects: $same the same bytes, $different different" > "$out/objects.txt"
for r in 1 2 3; do
    (cd scratch/objects-asm-a && BUSTER_PROBE=1 taskset -c 2 "$probe" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/musl-each-unit-p1-$r.txt")
    (cd scratch/objects-asm-b && BUSTER_PROBE=1 BUSTER_PROBE_ASM_CACHE=1 taskset -c 2 "$probe" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/musl-once-p1-$r.txt")
done
grep -l '__asm__\|\basm\b' scratch/musl-i/*.i | wc -l > "$out/units-with-asm.txt"
rm -rf scratch/objects-asm-a scratch/objects-asm-b
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
date -u +%FT%TZ > "$out/.done"

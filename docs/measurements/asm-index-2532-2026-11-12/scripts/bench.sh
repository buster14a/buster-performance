#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# bench.sh [ROUNDS]: musl's 1,336 units as one command (-c --lanes 1), main against head, inside one hold of the lock
# (lock.sh), CPU 2. Each round runs each way twice under perf stat, its order alternating from round to round: with the
# address space's randomization as it is, and with it off (setarch -R), with /proc/vmstat's huge-page counts around
# each run to tell its page state. Then every object of the last runs is compared between the ways.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-7}
out=$PWD/results/musl
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
for w in "${ways[@]}"; do
    rm -rf "scratch/objects-$w"
    mkdir -p "scratch/objects-$w"
    sha256sum "$(compiler_of "$w")" > "$out/compiler-$w.sha256"
done
run()
{
    local w=$1 v=$2 r=$3 compiler
    compiler=$(compiler_of "$w")
    local prefix=()
    if [[ $v == fixed ]]; then prefix=(setarch "$(uname -m)" -R); fi
    thp > "$out/vmstat-$w-$v-$r.txt"
    (cd "scratch/objects-$w" && taskset -c 2 perf stat -x, -o "$out/stat-$w-$v-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "${prefix[@]}" "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/stderr-$w-$v-$r.txt"; echo "$w $v $r status $?" >> "$out/status.txt")
    thp >> "$out/vmstat-$w-$v-$r.txt"
}
: > "$out/status.txt"
for ((r = 1; r <= rounds; r += 1)); do
    if ((r % 2)); then order=(main head); else order=(head main); fi
    for v in random fixed; do
        for w in "${order[@]}"; do
            run "$w" "$v" "$r"
        done
    done
done
same=0; different=0; missing=0
: > "$out/objects-different.txt"
for f in "${sources[@]}"; do
    n=${f##*/}; n=${n%.c}
    if [[ ! -f scratch/objects-main/$n.o || ! -f scratch/objects-head/$n.o ]]; then missing=$((missing + 1))
    elif cmp -s "scratch/objects-main/$n.o" "scratch/objects-head/$n.o"; then same=$((same + 1))
    else different=$((different + 1)); echo "$n" >> "$out/objects-different.txt"; fi
done
echo "objects: $same the same bytes, $different different, $missing missing, of ${#sources[@]} units" > "$out/objects.txt"
rm -rf scratch/objects-main scratch/objects-head
date -u +%FT%TZ > "$out/.done"

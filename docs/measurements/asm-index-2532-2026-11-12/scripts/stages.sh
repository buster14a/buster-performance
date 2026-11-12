#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stages.sh [RUNS]: musl's command with --time-stages, main and head in turn, RUNS runs each (default 3), CPU 2, with
# the address space's randomization off (setarch -R), inside one hold of the lock: each stage's milliseconds and the
# lowering's phases, among them lower.prepare, where the asm matcher's index was made.
set -u
cd "$(dirname "$0")"
. ./common.sh
runs=${1:-3}
out=$PWD/results/stages
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
for ((r = 1; r <= runs; r += 1)); do
    for w in "${ways[@]}"; do
        rm -rf "scratch/stages-$w"; mkdir -p "scratch/stages-$w"
        (cd "scratch/stages-$w" && taskset -c 2 setarch "$(uname -m)" -R "$(compiler_of "$w")" "${musl_options[@]}" --lanes 1 --time-stages -c "${sources[@]}" > /dev/null 2> "$out/stages-$w-$r.txt"; echo "$w $r status $?" >> "$out/status.txt")
    done
done
rm -rf scratch/stages-main scratch/stages-head
date -u +%FT%TZ > "$out/.done"

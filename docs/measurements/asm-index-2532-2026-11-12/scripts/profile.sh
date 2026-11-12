#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# profile.sh: one perf record of musl's command each way (user cycles, a sample every 100,000), CPU 2, the address
# space's randomization off, inside one hold of the lock; then each profile's functions by their share of the samples,
# and the matcher's (x86_match_*) and the index's making (check_asm_*) alone.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/profile
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
for w in "${ways[@]}"; do
    rm -rf "scratch/profile-$w"; mkdir -p "scratch/profile-$w"
    (cd "scratch/profile-$w" && taskset -c 2 setarch "$(uname -m)" -R perf record -q -e cycles:u -c 100000 -o "$out/perf-$w.data" -- "$(compiler_of "$w")" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1; echo "$w status $?" >> "$out/status.txt")
    perf report -i "$out/perf-$w.data" --no-children --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -40 > "$out/top-$w.txt"
    perf report -i "$out/perf-$w.data" --no-children --sort symbol --stdio 2> /dev/null | grep -E 'x86_match|check_asm_|strcmp|strchr|memcmp' > "$out/matcher-$w.txt"
    perf report -i "$out/perf-$w.data" --no-children --sort symbol --stdio 2> /dev/null | grep -E '^# (Samples|Event count)' > "$out/samples-$w.txt"
    rm -f "$out/perf-$w.data"
done
rm -rf scratch/profile-main scratch/profile-head
date -u +%FT%TZ > "$out/.done"

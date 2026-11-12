#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skip3.sh [ROUNDS]: skip2.sh's comparison for the generated glibc units preprocessed (scratch/glibc-i), inside one
# hold of the lock, CPU 2: read against skipped, every object compared, ROUNDS rounds (default 5) each way in turn under
# perf stat and the probe's stages each way (3 runs). skip2.sh has these units' sources; the units with the skipped
# tokens gone (semi.sh's glibc-live) are preprocessed, so what a skipped token still costs each stage, like for like,
# needs the preprocessed units skipped (tools/skip_residual.py).
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/skip3
here=$PWD
mkdir -p "$out" scratch/objects-skip-a scratch/objects-skip-b
probe=$PWD/src-probe/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$probe" scratch/glibc.skips > "$out/sha256.txt"
mapfile -t gnames < scratch/glibc-names.txt
units=("${gnames[@]/#/$here/scratch/glibc-i/}"); units=("${units[@]/%/.i}")
arguments=(--lanes 1 -c "${units[@]}")
same=0; different=0; missing=0
(cd scratch/objects-skip-a && rm -f ./*.o && taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/glibc-i.read.stderr.txt"; echo "glibc-i read status $?" > "$out/status.txt")
(cd scratch/objects-skip-b && rm -f ./*.o && BUSTER_PROBE_SKIPS="$here/scratch/glibc.skips" BUSTER_PROBE_SKIP_REPORT=1 taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/glibc-i.skipped.stderr.txt"; echo "glibc-i skipped status $?" >> "$out/status.txt")
for n in "${gnames[@]}"; do
    if [[ ! -f scratch/objects-skip-a/$n.o || ! -f scratch/objects-skip-b/$n.o ]]; then missing=$((missing + 1))
    elif cmp -s "scratch/objects-skip-a/$n.o" "scratch/objects-skip-b/$n.o"; then same=$((same + 1))
    else different=$((different + 1)); fi
done
echo "glibc-i objects: $same the same bytes, $different different, $missing missing; $(grep '^probe-skip' "$out/glibc-i.skipped.stderr.txt" | tail -n 1)" > "$out/objects.txt"
grep -v '^probe-skip' "$out/glibc-i.skipped.stderr.txt" | cmp -s - "$out/glibc-i.read.stderr.txt" && echo "glibc-i diagnostics: the same bytes ($(wc -c < "$out/glibc-i.read.stderr.txt") bytes)" >> "$out/objects.txt"
rm -f "$out/glibc-i.skipped.stderr.txt"
for ((r = 1; r <= rounds; r += 1)); do
    (cd scratch/objects-skip-a && taskset -c 2 perf stat -x, -o "$out/stat-glibc-i-read-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${arguments[@]}" > /dev/null 2>&1)
    (cd scratch/objects-skip-b && BUSTER_PROBE_SKIPS="$here/scratch/glibc.skips" taskset -c 2 perf stat -x, -o "$out/stat-glibc-i-skipped-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$probe" "${arguments[@]}" > /dev/null 2>&1)
done
for r in 1 2 3; do
    (cd scratch/objects-skip-a && BUSTER_PROBE=1 taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/glibc-i-read-p1-$r.txt")
    (cd scratch/objects-skip-b && BUSTER_PROBE=1 BUSTER_PROBE_SKIPS="$here/scratch/glibc.skips" taskset -c 2 "$probe" "${arguments[@]}" > /dev/null 2> "$out/glibc-i-skipped-p1-$r.txt")
done
rm -rf scratch/objects-skip-a scratch/objects-skip-b
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
python3 tools/skip_table.py "$out" > "$out/by-state.tsv"
date -u +%FT%TZ > "$out/.done"

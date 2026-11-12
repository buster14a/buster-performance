#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# glibc.sh [ROUNDS]: the emulation on a second header style, inside one hold of the lock: 512 generated units over the
# host's glibc headers (tools/gen_units.py), preprocessed, then as live2.sh does for musl: the rule emulated with a
# memo filled as the command goes (tools/attest.py), every object and the diagnostics compared between the units and
# their placeholder form, and ROUNDS rounds (default 5) of `-c` of the sources, of the preprocessed units and of the
# reduced ones as one command on one lane, CPU 2, with the probe's stages for the sources.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/glibc
here=$PWD
mkdir -p "$out" scratch/glibc-objects-a scratch/glibc-objects-b
compiler=$PWD/src/build/compiler
probe=$PWD/src-probe/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
rm -rf scratch/glibc-src scratch/glibc-i scratch/glibc-live scratch/glibc-semi
python3 tools/gen_units.py 512 scratch/glibc-src || status=1
mkdir -p scratch/glibc-i
: > "$out/preprocess.log"
for f in scratch/glibc-src/*.c; do
    b=${f##*/}; b=${b%.c}
    "$compiler" -E -P "$f" -o "scratch/glibc-i/$b.i" 2>> "$out/preprocess.log" || status=1
done
ls scratch/glibc-src | sed 's|^|x/|' > scratch/glibc-units.txt
python3 tools/attest.py --order scratch/glibc-units.txt --semi scratch/glibc-semi scratch/glibc-i scratch/glibc-live "$out/attest-glibc.tsv" > "$out/attest.log" 2>&1 || status=1
cat scratch/glibc-src/*.c | sha256sum > "$out/glibc-src.sha256"
cat scratch/glibc-i/*.i | sha256sum > "$out/glibc-i.sha256"
mapfile -t names < <(ls scratch/glibc-src | sed 's|\.c$||')
units=("${names[@]/#/$here/scratch/cur/}"); units=("${units[@]/%/.i}")
sources=("${names[@]/#/$here/scratch/glibc-src/}"); sources=("${sources[@]/%/.c}")
: > "$out/status.txt"
rm -f scratch/cur; ln -s "$here/scratch/glibc-i" scratch/cur
(cd scratch/glibc-objects-a && taskset -c 2 "$compiler" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/base.stderr.txt"; echo "base status $?" >> "$out/status.txt")
rm -f scratch/cur; ln -s "$here/scratch/glibc-semi" scratch/cur
(cd scratch/glibc-objects-b && taskset -c 2 "$compiler" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/other.stderr.txt"; echo "semi status $?" >> "$out/status.txt")
same=0; different=0; missing=0
for n in "${names[@]}"; do
    if [[ ! -f scratch/glibc-objects-a/$n.o || ! -f scratch/glibc-objects-b/$n.o ]]; then missing=$((missing + 1))
    elif cmp -s "scratch/glibc-objects-a/$n.o" "scratch/glibc-objects-b/$n.o"; then same=$((same + 1))
    else different=$((different + 1)); fi
done
echo "objects: $same the same bytes, $different different, $missing missing" > "$out/objects.txt"
if cmp -s "$out/base.stderr.txt" "$out/other.stderr.txt"; then echo "diagnostics: the same bytes ($(wc -c < "$out/base.stderr.txt") bytes, $(grep -c 'warning:' "$out/base.stderr.txt") warnings, $(grep -c 'error:' "$out/base.stderr.txt") errors)" >> "$out/objects.txt"
else echo "diagnostics: different" >> "$out/objects.txt"; fi
run()
{
    local name=$1 round=$2; shift 2
    (cd scratch/glibc-objects-a && taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" --lanes 1 -c "$@" > /dev/null 2>&1; echo "$name $round status $?" >> "$out/status.txt")
}
for ((r = 1; r <= rounds; r += 1)); do
    run c $r "${sources[@]}"
    rm -f scratch/cur; ln -s "$here/scratch/glibc-i" scratch/cur
    run i-c $r "${units[@]}"
    rm -f scratch/cur; ln -s "$here/scratch/glibc-live" scratch/cur
    run live-c $r "${units[@]}"
done
for r in 1 2 3; do
    (cd scratch/glibc-objects-a && BUSTER_PROBE=1 taskset -c 2 "$probe" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/glibc-c-p1-$r.txt")
done
rm -f scratch/cur
rm -rf scratch/glibc-objects-a scratch/glibc-objects-b
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

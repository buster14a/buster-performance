#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# semi.sh [ROUNDS]: the time of the placeholder units, inside one hold of the lock, CPU 2. In scratch/musl-semi
# (live2.sh's) every token of a skipped declaration is still a token, an empty declaration that the lexer, the parser
# and the reader's walk each take: more than the design leaves a skipped declaration (its tokens lexed and parsed as
# they were, and nothing read), so its compile is a measured upper estimate of the design's, where scratch/musl-live
# (the tokens gone) is a lower one. ROUNDS rounds (default 5) of `-c` of musl-i, musl-semi and musl-live as one command
# under perf stat, and the probe's stages for musl-semi; the same for the glibc units when scratch/glibc-semi is there.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:-5}
out=$PWD/results/semi
here=$PWD
mkdir -p "$out" scratch/objects-semi2
compiler=$PWD/src/build/compiler
probe=$PWD/src-probe/build/compiler
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
: > "$out/status.txt"
run_set()
{
    local label=$1 list=$2; shift 2
    local options=("$@")
    mapfile -t names < "$list"
    local units=("${names[@]/#/$here/scratch/cur/}"); units=("${units[@]/%/.i}")
    local r set
    for ((r = 1; r <= rounds; r += 1)); do
        for set in i semi live; do
            rm -f scratch/cur; ln -s "$here/scratch/$label-$set" scratch/cur
            (cd scratch/objects-semi2 && taskset -c 2 perf stat -x, -o "$out/stat-$label-$set-$r.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$compiler" "${options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2>&1; echo "$label-$set $r status $?" >> "$out/status.txt")
        done
    done
    for set in i semi live; do
        rm -f scratch/cur; ln -s "$here/scratch/$label-$set" scratch/cur
        for r in 1 2 3; do
            (cd scratch/objects-semi2 && BUSTER_PROBE=1 taskset -c 2 "$probe" "${options[@]}" --lanes 1 -c "${units[@]}" > /dev/null 2> "$out/$label-$set-p1-$r.txt")
        done
    done
    rm -f scratch/cur
}
sed 's|.*/||; s|\.c$||' scratch/musl-units.txt > scratch/musl-names.txt
run_set musl scratch/musl-names.txt "${musl_i_options[@]}"
if [[ -d scratch/glibc-semi ]]; then
    ls scratch/glibc-src | sed 's|\.c$||' > scratch/glibc-names.txt
    run_set glibc scratch/glibc-names.txt
fi
rm -rf scratch/objects-semi2
python3 tools/stat_medians.py "$out" > "$out/medians.tsv"
date -u +%FT%TZ > "$out/.done"

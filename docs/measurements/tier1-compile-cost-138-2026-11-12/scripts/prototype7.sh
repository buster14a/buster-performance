#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prototype7.sh CORPUS [RUNS]: the design's prototypes against today's compiler (laps7.patch): --tier1 -c of CORPUS
# (corpora.sh) on one lane, CPU 2, by the unpatched executable (src) and by the inst7 tree's as it is (two: today's two
# allocations, which in this executable also count, in every function, whether the plain assignment provably meets no
# constraint, a statistic today's compiler doesn't compute), with BUSTER_T1_PREFERRED_FIRST=3 (shared: one allocator
# call for both problems: validation, preparation, liveness, lists and intervals once, the plain assignment for its
# verdict, the preferred one over the same intervals, lookup, slot sharing and edge moves once), =4 (quiet: as shared,
# the plain assignment skipped where its whole range provably meets no constraint) and =5 (prefix: as shared, the plain
# assignment's verdict from the events before the last parameter's definition interval ends). Whole processes in a
# Williams design's order (runs.py), each configuration in a directory of its own, then a pass without perf for the
# peaks; every configuration's objects against src's, the functions that differ (tools/functions_differ.py), the
# --tier1-report lines and three lap logs of each of inst7's. The prototype keeps its state in globals: one lane only.
# Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-9}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
plain=$here/src/build/compiler
compiler=$here/inst7/build/compiler
out=$here/results/prototype7/$name
work=$here/scratch/prototype7-$name
configs=(src two shared quiet prefix)
declare -A mode=([two]=0 [shared]=3 [quiet]=4 [prefix]=5)
mkdir -p "$out"
for c in "${configs[@]}"; do mkdir -p "$work/$c"; done
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$plain" "$compiler" > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
for pass in runs peaks; do
    extra=(--runs "$runs")
    if [ "$pass" = peaks ]; then extra=(--plain --runs 3); fi
    python3 ./runs.py --cpus 2 "${extra[@]}" --out "$out/$pass.tsv" \
        --config src "$work/src" "$plain" "${arguments[@]}" \
        --config two "$work/two" env BUSTER_T1_PREFERRED_FIRST=0 "$compiler" "${arguments[@]}" \
        --config shared "$work/shared" env BUSTER_T1_PREFERRED_FIRST=3 "$compiler" "${arguments[@]}" \
        --config quiet "$work/quiet" env BUSTER_T1_PREFERRED_FIRST=4 "$compiler" "${arguments[@]}" \
        --config prefix "$work/prefix" env BUSTER_T1_PREFERRED_FIRST=5 "$compiler" "${arguments[@]}" > "$out/$pass.log" 2>&1 || status=1
done
for c in two shared quiet prefix; do
    for k in 1 2 3; do
        (cd "$work/$c" && BUSTER_T1_LAPS="$out/$c-$k.laps" BUSTER_T1_PREFERRED_FIRST=${mode[$c]} taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/$c.report.txt") || status=1
    done
done
: > "$out/objects.txt"
for c in "${configs[@]}"; do
    different=0
    : > "$out/$c.functions-differ.txt"
    for o in "$work"/src/*.o; do
        b=${o##*/}
        if ! cmp -s "$o" "$work/$c/$b"; then
            different=$((different + 1))
            echo "## $b" >> "$out/$c.functions-differ.txt"
            python3 tools/functions_differ.py "$o" "$work/$c/$b" >> "$out/$c.functions-differ.txt" 2>&1
        fi
    done
    echo "$c $(cd "$work/$c" && cat ./*.o | sha256sum | cut -d' ' -f1) objects $(ls "$work/$c" | wc -l) different from src's $different" >> "$out/objects.txt"
done
gzip -f "$out"/*.laps
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

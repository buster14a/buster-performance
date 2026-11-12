#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prototype6.sh CORPUS [RUNS]: the design's prototype against today's two allocations (laps6.patch), by one executable,
# the inst6 tree's: --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2, as it is (two), with
# BUSTER_T1_PREFERRED_FIRST=3 (shared: one allocator call for both problems: validation, preparation, liveness, lists
# and intervals once, the plain assignment for its verdict, the preferred one over the same intervals, lookup, slot
# sharing and edge moves once), with =4 (quiet: as shared, and the plain assignment skipped where it provably meets no
# constraint) and with =1 (one: laps3.patch's bound, the plain allocation put off in every function that calls, which
# changes the functions whose plain allocation meets a constraint). Whole processes in a Williams design's order
# (runs.py), each configuration in a directory of its own; then each configuration's objects' hashes, the functions
# whose bytes differ from two's (tools/functions_differ.py), the --tier1-report lines, and a lap log of each. The
# prototype keeps its state in globals: one lane only. Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/inst6/build/compiler
out=$here/results/prototype6/$name
work=$here/scratch/prototype6-$name
configs=(two shared quiet one)
declare -A mode=([two]=0 [shared]=3 [quiet]=4 [one]=1)
mkdir -p "$out"
for c in "${configs[@]}"; do mkdir -p "$work/$c"; done
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" \
    --config two "$work/two" env BUSTER_T1_PREFERRED_FIRST=0 "$compiler" "${arguments[@]}" \
    --config shared "$work/shared" env BUSTER_T1_PREFERRED_FIRST=3 "$compiler" "${arguments[@]}" \
    --config quiet "$work/quiet" env BUSTER_T1_PREFERRED_FIRST=4 "$compiler" "${arguments[@]}" \
    --config one "$work/one" env BUSTER_T1_PREFERRED_FIRST=1 "$compiler" "${arguments[@]}" > "$out/runs.log" 2>&1 || status=1
for c in "${configs[@]}"; do
    for k in 1 2 3; do
        (cd "$work/$c" && BUSTER_T1_LAPS="$out/$c-$k.laps" BUSTER_T1_PREFERRED_FIRST=${mode[$c]} taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/$c.report.txt") || status=1
    done
    (cd "$work/$c" && sha256sum ./*.o) > "$out/$c.objects.txt"
done
for c in shared quiet one; do
    : > "$out/$c.functions-differ.txt"
    for o in "$work"/two/*.o; do
        b=${o##*/}
        if ! cmp -s "$o" "$work/$c/$b"; then
            echo "## $b" >> "$out/$c.functions-differ.txt"
            python3 tools/functions_differ.py "$o" "$work/$c/$b" >> "$out/$c.functions-differ.txt" 2>&1
        fi
    done
done
gzip -f "$out"/*.laps
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

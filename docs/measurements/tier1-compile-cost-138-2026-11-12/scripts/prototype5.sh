#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prototype5.sh CORPUS [RUNS]: one allocation's two prototypes against today's two allocations (laps5.patch), by one
# executable, the inst5 tree's: --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2, as it is (two), with
# BUSTER_T1_PREFERRED_FIRST=1 (one: the plain allocation put off in every function that calls) and with =2 (exact: put
# off only where it provably meets no constraint, t1_plain_unconstrained). Whole processes in a Williams design's order
# (runs.py), each in a directory of its own; then each configuration's objects' hashes, the functions whose bytes
# differ from two's (tools/functions_differ.py), the --tier1-report lines, and a lap log of each (two's G lines say
# what became of every second allocation and whether the test passes). Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/inst5/build/compiler
out=$here/results/prototype5/$name
work=$here/scratch/prototype5-$name
mkdir -p "$out" "$work/two" "$work/one" "$work/exact"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" \
    --config two "$work/two" "$compiler" "${arguments[@]}" \
    --config one "$work/one" env BUSTER_T1_PREFERRED_FIRST=1 "$compiler" "${arguments[@]}" \
    --config exact "$work/exact" env BUSTER_T1_PREFERRED_FIRST=2 "$compiler" "${arguments[@]}" > "$out/runs.log" 2>&1 || status=1
(cd "$work/two" && BUSTER_T1_LAPS="$out/two.laps" taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/two.report.txt") || status=1
(cd "$work/one" && BUSTER_T1_LAPS="$out/one.laps" BUSTER_T1_PREFERRED_FIRST=1 taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/one.report.txt") || status=1
(cd "$work/exact" && BUSTER_T1_LAPS="$out/exact.laps" BUSTER_T1_PREFERRED_FIRST=2 taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/exact.report.txt") || status=1
for c in two one exact; do
    (cd "$work/$c" && sha256sum ./*.o) > "$out/$c.objects.txt"
done
for c in one exact; do
    : > "$out/$c.functions-differ.txt"
    for o in "$work"/two/*.o; do
        b=${o##*/}
        if ! cmp -s "$o" "$work/$c/$b"; then
            echo "## $b" >> "$out/$c.functions-differ.txt"
            python3 tools/functions_differ.py "$o" "$work/$c/$b" >> "$out/$c.functions-differ.txt" 2>&1
        fi
    done
done
gzip -f "$out/two.laps" "$out/one.laps" "$out/exact.laps"
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

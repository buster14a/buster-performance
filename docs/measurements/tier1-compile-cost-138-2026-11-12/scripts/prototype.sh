#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prototype.sh CORPUS [RUNS]: one allocation's prototype against today's two (laps3.patch), by one executable, the
# inst3 tree's: --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2, as it is and with BUSTER_T1_PREFERRED_FIRST=1,
# whole processes in a Williams design's order (runs.py), each in a directory of its own. Then each object's hash, the
# functions whose bytes differ between the two (tools/functions_differ.py), both --tier1-report lines, and one lap log
# of each (the first's G lines say what became of every second allocation). Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/inst3/build/compiler
out=$here/results/prototype/$name
work=$here/scratch/prototype-$name
mkdir -p "$out" "$work/two" "$work/one"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" \
    --config two "$work/two" "$compiler" "${arguments[@]}" \
    --config one "$work/one" env BUSTER_T1_PREFERRED_FIRST=1 "$compiler" "${arguments[@]}" > "$out/runs.log" 2>&1 || status=1
(cd "$work/two" && BUSTER_T1_LAPS="$out/two.laps" taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/two.report.txt") || status=1
(cd "$work/one" && BUSTER_T1_LAPS="$out/one.laps" BUSTER_T1_PREFERRED_FIRST=1 taskset -c 2 "$compiler" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/one.report.txt") || status=1
(cd "$work/two" && sha256sum ./*.o) > "$out/two.objects.txt"
(cd "$work/one" && sha256sum ./*.o) > "$out/one.objects.txt"
: > "$out/functions-differ.txt"
for o in "$work"/two/*.o; do
    b=${o##*/}
    if ! cmp -s "$o" "$work/one/$b"; then
        echo "## $b" >> "$out/functions-differ.txt"
        python3 tools/functions_differ.py "$o" "$work/one/$b" >> "$out/functions-differ.txt" 2>&1
    fi
done
gzip -f "$out/two.laps" "$out/one.laps"
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

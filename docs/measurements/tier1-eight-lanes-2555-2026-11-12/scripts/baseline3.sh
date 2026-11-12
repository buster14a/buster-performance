#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# baseline3.sh CORPUS LANES [RUNS]: the default compile against --tier1, as whole processes in a Williams design's
# order, each configuration writing its objects in a directory of its own (runs.py). It supersedes baseline.sh, whose
# time-runs wrote both configurations' objects over each other (a --tier1 object over the default's longer one waited
# 20 ms for the file system's truncation), and baseline2.sh, which read no wall time from this perf and took the peaks
# under it. Two passes: under perf (wall time, cycles, instructions), then without it, 3 rounds, for wait4's peaks.
# Then one --tier1 --tier1-report compile, the objects' sizes and, on one lane, each one's --time-stages reports (3).
# CORPUS is sqlite, lua or musl (corpora.sh); LANES is 1 (CPU 2, --lanes 1) or 8 (CPUs 0-7, one a core, --lanes 8).
# Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
lanes=${2:?1 or 8}
runs=${3:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/src/build/compiler
out=$here/results/baseline3/$name-$lanes
work=$here/scratch/baseline3-$name-$lanes
mkdir -p "$out" "$work/default" "$work/tier1"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
if [ "$lanes" = 1 ]; then cpus=2; else cpus=0-7; fi
echo "units ${#files[@]}" > "$out/units.txt"
cat "${files[@]}" | wc -c >> "$out/units.txt"
python3 ./runs.py --cpus "$cpus" --runs "$runs" --out "$out/runs.tsv" \
    --config default "$work/default" "$compiler" "${options[@]}" --lanes "$lanes" -c "${files[@]}" \
    --config tier1 "$work/tier1" "$compiler" --tier1 "${options[@]}" --lanes "$lanes" -c "${files[@]}" > "$out/runs.log" 2>&1 || status=1
python3 ./runs.py --plain --cpus "$cpus" --runs 3 --out "$out/peaks.tsv" \
    --config default "$work/default" "$compiler" "${options[@]}" --lanes "$lanes" -c "${files[@]}" \
    --config tier1 "$work/tier1" "$compiler" --tier1 "${options[@]}" --lanes "$lanes" -c "${files[@]}" > "$out/peaks.log" 2>&1 || status=1
(cd "$work/tier1" && taskset -c "$cpus" "$compiler" --tier1 --tier1-report "${options[@]}" --lanes "$lanes" -c "${files[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/tier1-report.txt") || status=1
for c in default tier1; do
    (cd "$work/$c" && echo "$c objects $(ls | wc -l) bytes $(cat ./*.o | wc -c)" >> "$out/units.txt")
done
if [ "$lanes" = 1 ]; then
    for r in 1 2 3; do
        (cd "$work/default" && taskset -c "$cpus" "$compiler" --time-stages "${options[@]}" --lanes 1 -c "${files[@]}" 2>&1 > /dev/null | grep '^time-' > "$out/stages-default-$r.txt") || status=1
        (cd "$work/tier1" && taskset -c "$cpus" "$compiler" --time-stages --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" 2>&1 > /dev/null | grep '^time-' > "$out/stages-tier1-$r.txt") || status=1
    done
fi
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

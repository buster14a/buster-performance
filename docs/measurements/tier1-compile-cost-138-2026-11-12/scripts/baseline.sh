#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# baseline.sh CORPUS LANES [RUNS]: the default compile against --tier1, as whole processes in a Williams design's
# order (time-runs: wall time, user and system time, wait4's peak, faults, user cycles and instructions of every
# thread), then one --tier1 --tier1-report compile and, on one lane, each one's --time-stages report. CORPUS is sqlite,
# lua or musl (corpora.sh); LANES is 1 (pinned to CPU 2, --lanes 1) or 8 (CPUs 0-7, one a core, --lanes 8). Run inside
# one hold of the lock (lock.sh ./baseline.sh ...). The objects go to a scratch directory, removed after.
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
out=$here/results/baseline/$name-$lanes
work=$here/scratch/baseline-$name-$lanes
mkdir -p "$out" "$work"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
if [ "$lanes" = 1 ]; then cpus=2; else cpus=0-7; fi
cd "$work" || exit 1
echo "units ${#files[@]}" > "$out/units.txt"
cat "${files[@]}" | wc -c >> "$out/units.txt"
taskset -c "$cpus" "$compiler" time-runs --runs "$runs" \
    --list "${options[@]}" --lanes "$lanes" -c "${files[@]}" \
    --list --tier1 "${options[@]}" --lanes "$lanes" -c "${files[@]}" > "$out/time-runs.txt" 2>&1 || status=1
taskset -c "$cpus" "$compiler" --tier1 --tier1-report "${options[@]}" --lanes "$lanes" -c "${files[@]}" > "$out/tier1-report.stdout.txt" 2> "$out/tier1-report.txt" || status=1
if [ "$lanes" = 1 ]; then
    for r in 1 2 3; do
        taskset -c "$cpus" "$compiler" --time-stages "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2> "$out/stages-default-$r.txt" || status=1
        taskset -c "$cpus" "$compiler" --time-stages --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2> "$out/stages-tier1-$r.txt" || status=1
    done
fi
ls | wc -l >> "$out/units.txt"
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

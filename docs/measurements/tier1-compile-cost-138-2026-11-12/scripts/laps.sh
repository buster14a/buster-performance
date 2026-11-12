#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# laps.sh CORPUS [RUNS]: the lap log (laps.patch) of the instrumented tree's compiles of CORPUS (corpora.sh) on one
# lane, pinned to CPU 2: RUNS (default 5) of the default compile and of --tier1, alternating, each in a directory of
# its own, each log gzipped. No perf: the laps' TSC alone, exact per stage and per function. Run inside one hold of the
# lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-5}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/inst/build/compiler
out=$here/results/laps/$name
work=$here/scratch/laps-$name
mkdir -p "$out" "$work/default" "$work/tier1"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$compiler" > "$out/compiler.txt"
# One uncounted compile of each first, so that every logged run follows a compile.
(cd "$work/default" && taskset -c 2 "$compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1) || status=1
(cd "$work/tier1" && taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1) || status=1
for ((r = 1; r <= runs; r += 1)); do
    (cd "$work/default" && BUSTER_T1_LAPS="$out/default-$r.laps" taskset -c 2 "$compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1) || status=1
    (cd "$work/tier1" && BUSTER_T1_LAPS="$out/tier1-$r.laps" taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1) || status=1
done
gzip -f "$out"/*.laps
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

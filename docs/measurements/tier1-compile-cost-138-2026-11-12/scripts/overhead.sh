#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# overhead.sh [RUNS]: what the lap log costs: --tier1 -c of sqlite3.c by the unpatched tree, by the instrumented one
# with the log off, and with it on (written to scratch), and the default compile by the first two; whole processes in a
# Williams design's order (runs.py), each in a directory of its own, on CPU 2. Then the three --tier1 objects' hashes,
# which must be one. Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
runs=${1:-7}
out=$here/results/overhead
work=$here/scratch/overhead
mkdir -p "$out" "$work"/{src-tier1,inst-tier1,inst-laps,src-default,inst-default}
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
arguments=("${sqlite_options[@]}" --lanes 1 -c "${sqlite_files[@]}")
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" \
    --config src-tier1 "$work/src-tier1" "$here/src/build/compiler" --tier1 "${arguments[@]}" \
    --config inst-tier1 "$work/inst-tier1" "$here/inst/build/compiler" --tier1 "${arguments[@]}" \
    --config inst-laps "$work/inst-laps" env "BUSTER_T1_LAPS=$work/laps.txt" "$here/inst/build/compiler" --tier1 "${arguments[@]}" \
    --config src-default "$work/src-default" "$here/src/build/compiler" "${arguments[@]}" \
    --config inst-default "$work/inst-default" "$here/inst/build/compiler" "${arguments[@]}" > "$out/runs.log" 2>&1 || status=1
sha256sum "$work"/*/sqlite3.o > "$out/objects.txt"
sha256sum "$here/src/build/compiler" "$here/inst/build/compiler" >> "$out/objects.txt"
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

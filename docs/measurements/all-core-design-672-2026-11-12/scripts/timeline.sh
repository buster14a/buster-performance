#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# timeline.sh TAG UNIT WORKERS [INTERVAL_MS]: DRAM traffic by stage, inside one hold of the lock. One cohort of UNIT's
# -c (--lanes 1 --time-stages, 6 compiles a worker at 1 worker and 4 at 8) under `perf stat -a -I` of the memory
# controllers' read and write CAS commands (every 2 ms by default); `allcore umcstages` then divides each interval's
# count among the stages the cohort's runs were in. The UMC's counts are system-wide: they are the compiles' and
# whatever else the host moved (the idle rate is in baseline.sh's controls).
set -u
cd "$(dirname "$0")"
. ./common.sh
tag=${1:?a tag} unit=${2:?a unit} workers=${3:?w1 or w8} interval=${4:-2}
label="$tag-timeline.$workers"
cpus=$(cpus_of "$label") || exit 1
loops=$([[ $workers == w1 ]] && echo 6 || echo 4)
out=results/timeline
mkdir -p "$out/stages" scratch
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$label.holder.txt"
: > "$out/$label.strays.txt"
strays "$out" "$label" before
perf stat -a -x, -I "$interval" -o "$out/$label.intervals.csv" -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/ -- \
    ./allcore cohort --cpus "$cpus" --loops "$loops" --label "$label" --out "$out/$label.rows.tsv" --stderr "$out/stages/$label.w%w.r%i.txt" -- \
    "$compiler" --time-stages --lanes 1 -c "${SQLITE_OPTIONS[@]}" "$unit" -o "scratch/$label.w%w.o" > "$out/$label.log" 2>&1 || status=1
strays "$out" "$label" after
./allcore umcstages --rows "$out/$label.rows.tsv" --stages "$out/stages/$label.w%w.r%i.txt" --timeline "$out/$label.intervals.csv" > "$out/$label.umcstages.tsv" 2>> "$out/$label.log" || status=1
gzip -f "$out/$label.intervals.csv"
if ((status == 0)); then date -u +%FT%TZ > "$out/$label.done"; fi
exit $status

#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# latency.sh ROUND: what an L3 miss costs by worker count, inside one hold of the lock: the frozen sqlite3.c's -c at
# 1, 2, 4, 8 and 15 workers (6 compiles a worker, 4 on 15; each run counted, common.sh's LAT set), each cohort under the
# L3's sampled miss latency (l3_xi_sampled_latency and its requests, DRAM near; perf's l3_read_miss_latency is their
# ratio times 10 ns), the L3's lookups and the memory controllers' CAS commands, on every CPU.
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=results/latency/r$round
mkdir -p "$out/stages" scratch
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
L3=l3_xi_sampled_latency.dram_near,l3_xi_sampled_latency_requests.dram_near,l3_lookup_state.l3_miss,l3_lookup_state.l3_hit
labels=(sq.w1 sq.w2 sq.w4 sq.w8 sq.w15)
n=${#labels[@]}
for ((s = 0; s < n; s += 1)); do
    label=${labels[(s + round) % n]}
    cpus=$(cpus_of "$label")
    loops=6
    [[ $label == sq.w15 ]] && loops=4
    : > "$out/$label.strays.txt"
    strays "$out" "$label" before
    perf stat -a -x, -o "$out/$label.l3.csv" -e "$L3" -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/ -- \
        ./allcore cohort --cpus "$cpus" --loops "$loops" --label "$label" --out "$out/$label.rows.tsv" --events "$EVENTS_LAT" --stderr "$out/stages/$label.w%w.r%i.txt" -- \
        "$compiler" --time-stages --lanes 1 -c "${SQLITE_OPTIONS[@]}" "$sqlite/sqlite3.c" -o "scratch/$label.w%w.o" || { status=1; echo "$label failed" >&2; }
    strays "$out" "$label" after
done
perf stat -a -x, -o "$out/idle.l3.csv" -e "$L3" -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/ -- sleep 2 || status=1
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

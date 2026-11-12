#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# stagecounters.sh [RUNS]: counters by stage, with and without -g, the one-core record's method: each run is one
# `-c --time-stages` compile of the frozen sqlite3.c on CPU 2 under a leader-sampled perf group with sample times, its
# own stage report beside it, so that tools/stagebuckets can put every sample in the stage its time falls in. RUNS runs
# (6) of each, in turn, inside one hold of the lock (lock.sh ./stagecounters.sh).
set -u
cd "$(dirname "$0")"
. ./common.sh
runs=${1:-6}
out=$here/results/stagecounters
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S'
for ((r = 1; r <= runs; r += 1)); do
    for variant in c cg; do
        g=""
        if [[ $variant == cg ]]; then g=-g; fi
        taskset -c 5 perf record -q -T -o "$t/o/sc.data" -e "$events" -c 100003 -- \
            taskset -c 2 "$c" --time-stages -c $g $ct "$sqlite/sqlite3.c" -o "$t/o/sc-$variant.o" > /dev/null 2> "$out/$variant-$r.stages.txt" || status=1
        perf script -i "$t/o/sc.data" -F time,period,event,ip,sym 2>> "$out/script.log" | gzip -c > "$out/$variant-$r.samples.gz" || status=1
        rm -f "$t/o/sc.data"
    done
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

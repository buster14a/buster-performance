#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# muslprofile.sh [RUNS]: musl's 1,336 units as one command on one lane (CPU 2), with and without -g, under a
# leader-sampled group, by function: a many-unit command reports its units' stages as one, so the functions' names
# stand for -g's work. RUNS runs (2) of each, in turn, and one of each under a cycles profile that holds the kernel,
# inside one hold of the lock (lock.sh ./muslprofile.sh).
set -u
cd "$(dirname "$0")"
. ./common.sh
runs=${1:-2}
out=$here/results/muslprofile
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S'
for ((r = 1; r <= runs; r += 1)); do
    for variant in c cg; do
        g=""
        if [[ $variant == cg ]]; then g=-g; fi
        (cd "$t/m/$variant" && taskset -c 5 perf record -q -T -o "$t/o/mp.data" -e "$events" -c 100003 -- \
            taskset -c 2 "$c" $mo --lanes 1 -c $g @$t/lists/units1336.txt > /dev/null 2>&1) || status=1
        perf script -i "$t/o/mp.data" -F time,period,event,ip,sym 2>> "$out/script.log" | gzip -c > "$out/$variant-$r.samples.gz" || status=1
        rm -f "$t/o/mp.data"
    done
done
for variant in c cg; do
    g=""
    if [[ $variant == cg ]]; then g=-g; fi
    (cd "$t/m/$variant" && taskset -c 5 perf record -q -o "$t/o/mp.data" -e cycles -c 100003 -- \
        taskset -c 2 "$c" $mo --lanes 1 -c $g @$t/lists/units1336.txt > /dev/null 2>&1) || status=1
    perf report -i "$t/o/mp.data" --no-children --sort dso --stdio -q > "$out/$variant-cycles-dso.txt" 2>> "$out/script.log" || status=1
    perf report -i "$t/o/mp.data" --no-children --sort dso,sym --stdio -q --percent-limit 0.3 > "$out/$variant-cycles.txt" 2>> "$out/script.log" || status=1
    rm -f "$t/o/mp.data"
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# profile.sh [RUNS]: musl's command RUNS times (5) for each tree under one instructions:u profile (CPU 2, perf on CPU 5),
# by symbol, one hold of the lock (lock.sh ./profile.sh). The period, 1,000,003, keeps the samples below the kernel's
# perf_event_max_sample_rate (recorded in perf-rate.txt) at about 14 G instructions a second, so that the samples'
# periods sum to the instructions counted (sum.txt); a smaller one is throttled and undercounts.
set -u
cd "$(dirname "$0")"
. ./common.sh
runs=${1:-5}
out=$here/results/profile
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
cat /proc/sys/kernel/perf_event_max_sample_rate > "$out/perf-rate.txt"
status=0
for tree in $trees; do
    c=$root/$tree/build/compiler
    (cd "$t/m/$tree" && taskset -c 5 perf record -q -o "$t/o/p.data" -e instructions:u -c 1000003 -- \
        bash -c "for ((i = 0; i < $runs; i += 1)); do taskset -c 2 $c $mo --lanes 1 -c @$t/lists/units1336.txt > /dev/null 2>&1 || exit 1; done") || status=1
    perf report -i "$t/o/p.data" --no-children --sort sym --stdio -q -F overhead,period,sym > "$out/$tree-instructions.txt" 2>> "$out/script.log" || status=1
    awk -v tree=$tree -v runs=$runs '{ total += $2 } END { printf "%s\t%d runs\t%.1f M sampled instructions a run\n", tree, runs, total / runs / 1e6 }' "$out/$tree-instructions.txt" >> "$out/sum.txt"
    rm -f "$t/o/p.data"
done
exit $status

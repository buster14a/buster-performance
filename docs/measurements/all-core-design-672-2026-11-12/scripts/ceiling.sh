#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# ceiling.sh MODE: the host's DRAM bandwidth under a stream, on 1 worker (CPU 2) and on 8 (CPUs 0 to 7), inside one hold
# of the lock: `allcore membw` in MODE (read, write, nt or copy; 1 GB a worker, 2 s) under the memory controllers'
# counters, read every 100 ms: the stream is the last 2 s of the command (its buffers' first touch comes before), so
# tables.sh takes the intervals from 1.8 s to 0.2 s before the last. What the bus moves there is the ceiling the
# compiles' traffic is read against.
set -u
cd "$(dirname "$0")"
. ./common.sh
mode=${1:?a mode}
out=results/ceiling
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$mode.holder.txt"
for workers in w1 w8; do
    cpus=$(cpus_of "x.$workers")
    : > "$out/$mode.$workers.strays.txt"
    strays "$out" "$mode.$workers" before
    perf stat -a -x, -I 100 -o "$out/$mode.$workers.intervals.csv" -e "$UMC" -- ./allcore membw --cpus "$cpus" --mode "$mode" > "$out/$mode.$workers.tsv" || status=1
    strays "$out" "$mode.$workers" after
done
if ((status == 0)); then date -u +%FT%TZ > "$out/$mode.done"; fi
exit $status

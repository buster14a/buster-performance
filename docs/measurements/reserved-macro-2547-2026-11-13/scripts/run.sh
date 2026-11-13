#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# run.sh ROUNDS [FIRST]: procbench on lists/ab.list for ROUNDS rounds (from round FIRST), the lines rotated each round,
# inside one hold of the lock (lock.sh ./run.sh ROUNDS), with the harness on CPU 2; results/ab/runs.tsv, and its
# medians in results/ab/medians.tsv.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=${1:?rounds}
first=${2:-1}
out=$here/results/ab
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '1,6p' >> "$out/others.txt"
header=()
if ((first > 1)); then header=(--no-header); fi
taskset -c 2 tools/procbench --rounds "$rounds" --first "$first" "${header[@]}" --out "$out" lists/ab.list >> "$out/runs.tsv" 2>> "$out/errors.txt" < /dev/null
status=$?
ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '1,6p' >> "$out/others.txt"
tools/medians "$out/runs.tsv" > "$out/medians.tsv"
echo "rounds $first to $((first + rounds - 1)): status $status at $(date -u +%FT%TZ)" >> "$out/done.txt"
exit $status

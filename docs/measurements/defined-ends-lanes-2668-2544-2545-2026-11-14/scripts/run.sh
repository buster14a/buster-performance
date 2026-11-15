#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# run.sh LIST ROUNDS FIRST [busy]: procbench on lists/LIST.list for ROUNDS rounds from round FIRST, the lines rotated
# each round, inside one hold of the lock (lock.sh ./run.sh ...), into results/LIST[-busy]/runs.tsv and its medians.
# With `busy`, tools/spin computes on CPU 7 all the while: the busy list's lanes one CPU short, on purpose (#2545).
set -u
cd "$(dirname "$0")"
. ./common.sh
list=${1:?list}
rounds=${2:?rounds}
first=${3:?first}
busy=${4:-}
out=$here/results/$list${busy:+-busy}
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
{
    echo "## before, $(date -u +%FT%TZ): cpu, %cpu, elapsed, command"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,5p'
} >> "$out/others.txt"
spinner=0
if [[ -n $busy ]]; then
    taskset -c 7 tools/spin 600 &
    spinner=$!
    sleep 0.2
fi
header=()
if ((first > 1)); then header=(--no-header); fi
taskset -c 2 tools/procbench --rounds "$rounds" --first "$first" "${header[@]}" --out "$out" "lists/$list.list" >> "$out/runs.tsv" 2>> "$out/errors.txt" < /dev/null
status=$?
if ((spinner != 0)); then kill $spinner; wait $spinner 2> /dev/null; fi
{
    echo "## after, $(date -u +%FT%TZ)"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,5p'
} >> "$out/others.txt"
tools/medians "$out/runs.tsv" > "$out/medians.tsv"
echo "rounds $first to $((first + rounds - 1)): status $status at $(date -u +%FT%TZ)" >> "$out/done.txt"
exit $status

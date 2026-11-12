#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# run.sh NAME ROUNDS [FIRST]: procbench on lists/NAME.list for ROUNDS rounds (from round FIRST), inside one hold of the
# lock (lock.sh ./run.sh NAME ROUNDS). The runs go to results/NAME/runs.tsv (appended with FIRST past 1) and a list's
# captured reports to results/NAME/. The harness itself waits on CPU 2 with a one-core list's commands, as
# measure-compile's and time-runs' callers pin them (HARNESS_CPU names another), and on no CPU of its own with an
# eight-core list's.
set -u
cd "$(dirname "$0")"
. ./common.sh
name=${1:?a list}
rounds=${2:?rounds}
first=${3:-1}
out=$here/results/$name
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
# What else runs: the busiest processes before the run and after it, with the CPU each is on (a process outside the lock
# that holds one of an eight-core list's CPUs leaves its lanes a CPU short).
others()
{
    echo "## $1 rounds $first to $((first + rounds - 1)), $(date -u +%FT%TZ): cpu, %cpu, elapsed, command" >> "$out/others.txt"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,5p' >> "$out/others.txt"
}
others before
pin=(taskset -c "${HARNESS_CPU:-2}")
if grep -q 'cpus=0-7' "lists/$name.list"; then pin=(); fi
header=()
if ((first > 1)); then header=(--no-header); fi
"${pin[@]}" tools/procbench --rounds "$rounds" --first "$first" "${header[@]}" --out "$out" "lists/$name.list" >> "$out/runs.tsv" 2>> "$out/errors.txt" < /dev/null
status=$?
others after
echo "rounds $first to $((first + rounds - 1)): status $status at $(date -u +%FT%TZ)" >> "$out/done.txt"
exit $status

#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# busy.sh CONDITION ROUNDS: the links and the builds of lists/busy.list on CPUs 0 to 7, alone (`free`) or beside one
# other process that computes on CPU 7 all the while (`busy`: tools/spin, pinned there), inside one hold of the lock
# (lock.sh ./busy.sh CONDITION ROUNDS). The runs go to results/busy-CONDITION/.
set -u
cd "$(dirname "$0")"
. ./common.sh
condition=${1:?free or busy}
rounds=${2:?rounds}
out=$here/results/busy-$condition
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
spinner=0
if [[ $condition == busy ]]; then
    taskset -c 7 tools/spin 600 &
    spinner=$!
    sleep 0.2
fi
{
    echo "## before, $(date -u +%FT%TZ): cpu, %cpu, elapsed, command"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,5p'
} >> "$out/others.txt"
tools/procbench --rounds "$rounds" --out "$out" lists/busy.list >> "$out/runs.tsv" 2>> "$out/errors.txt" < /dev/null
status=$?
{
    echo "## after, $(date -u +%FT%TZ)"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,5p'
} >> "$out/others.txt"
if ((spinner != 0)); then kill $spinner; wait $spinner 2> /dev/null; fi
echo "rounds $rounds: status $status at $(date -u +%FT%TZ)" >> "$out/done.txt"
exit $status

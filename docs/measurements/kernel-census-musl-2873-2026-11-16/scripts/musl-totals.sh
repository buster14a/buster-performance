#!/bin/bash
# musl-totals.sh ROUNDS: CPU 2's own counts (perf stat -C 2) over the units a process each, the harness alone (true in
# each compile's place) and the units as one command on one lane; the three in turn, ROUNDS rounds; perf on CPU 4. In
# one hold of the lock (lock.sh ./musl-totals.sh 3).
set -u
cd "$(dirname "$0")"
here=$PWD
rounds=${1:-3}
out=results/musl
mkdir -p "$out"
compiler=$here/src/build/compiler
events=cycles:k,cycles:u,instructions:k,instructions:u,page-faults,context-switches
stamp=$(date -u +%Y%m%dT%H%M%SZ)
status=0
{ echo "== totals $stamp"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((round = 0; round < rounds; round += 1)); do
    for mode in units true command; do
        taskset -c 4 perf stat -C 2 -x, -e "$events" -o "$out/totals-$stamp-$mode-$round.csv" -- \
            taskset -c 2 bash scripts/musl-loop.sh "$mode" "$compiler" > /dev/null 2> "$out/totals-$stamp-$mode-$round.err" || status=1
    done
done
{ echo "status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
exit $status

#!/bin/bash
# small.sh RUNS (inside one hold): time-runs of base and head, three fresh copies each, on CPU 2, over three of
# c-testsuite's units as single-file processes: each list one file, -c to tmpfs.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/timing
mkdir -p "$out" $t/copies-small
log=$out/small-$(date -u +%H%M%S).txt
head -1 /var/lib/buster-9700x/owner > "$log"
lists=()
for f in 00050 00100 00170; do lists+=(--list -c $cts/$f.c -o $t/o/small.o); done
taskset -c 2 "$base" time-runs --runs "$1" --warmups 2 --copies 3 --directory $t/copies-small --build base "$base" --build head "$head" "${lists[@]}" >> "$log" 2>&1
echo "status $?" >> "$log"
grep -v "^run " "$log"

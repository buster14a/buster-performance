#!/usr/bin/env bash
# The switch build's modes on one executable (layout-free): 8 rounds, the order rotated by round, each mode a discarded
# warm-up compile then perf stat -r 3 of the compile, pinned to CPU 2. One hold of the host's lock for all of it.
set -u
source "$(dirname "$0")/common.sh"
mkdir -p "$D/perf"
for round in 0 1 2 3 4 5 6 7; do
    for i in 0 1 2; do
        m=${modes[$(( (round + i) % 3 ))]}
        BUSTER_569_VALIDATE=$m taskset -c 2 "$D/switch/build/compiler" "${options[@]}" -o "$TMPDIR/c-$m.o"
        BUSTER_569_VALIDATE=$m taskset -c 2 perf stat -r 3 -e "$events" -o "$D/perf/c-$round-$m.txt" -- "$D/switch/build/compiler" "${options[@]}" -o "$TMPDIR/c-$m.o"
        echo "round $round $m status $?"
    done
done

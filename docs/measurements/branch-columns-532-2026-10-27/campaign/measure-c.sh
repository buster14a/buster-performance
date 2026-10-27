#!/usr/bin/env bash
# The switch build's modes on one executable (layout-free): 8 rounds, the order rotated, each a discarded warm-up then
# perf stat -r 3.
set -u
source ./common.sh
modes=(full vector scalar)
for round in 0 1 2 3 4 5 6 7; do
    for i in 0 1 2; do
        m=${modes[$(( (round + i) % 3 ))]}
        BUSTER_532_CHECK=$m taskset -c 2 ./switch/build/compiler "${options[@]}" -o out/c-$m.o
        BUSTER_532_CHECK=$m taskset -c 2 perf stat -r 3 -e "$events" -o out/c-$round-$m.txt -- ./switch/build/compiler "${options[@]}" -o out/c-$m.o
        echo "round $round $m status $?"
    done
done

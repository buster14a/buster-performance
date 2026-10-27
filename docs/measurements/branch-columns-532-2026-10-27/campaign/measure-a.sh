#!/usr/bin/env bash
# main against the branch, whole compiles: 8 rounds in alternating order, each a discarded warm-up then perf stat -r 3.
set -u
source ./common.sh
for round in 1 2 3 4 5 6 7 8; do
    if (( round % 2 )); then order=(main head); else order=(head main); fi
    for v in "${order[@]}"; do
        taskset -c 2 ./$v/build/compiler "${options[@]}" -o out/a-$v.o
        taskset -c 2 perf stat -r 3 -e "$events" -o out/a-$round-$v.txt -- ./$v/build/compiler "${options[@]}" -o out/a-$v.o
        echo "round $round $v status $?"
    done
done

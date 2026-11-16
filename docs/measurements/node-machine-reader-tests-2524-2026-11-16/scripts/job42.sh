#!/bin/bash
# job42.sh: is the second pass's difference on musl inside its ticks? w2 and z3 in turn, three times, the whole kernel
# with a body a window and with 4,096 records a window.
set -u
cd "$(dirname "$0")"
for round in 1 2 3; do
    for label in w2 z3; do
        ./facts-gdb-musl.sh $label whole-$round --passes 5
        ./facts-gdb-musl.sh $label packed4096-$round --facts-packed --facts-window 4096 --passes 5
    done
done
echo "job42 done $(date -u +%FT%TZ)" >> results/job42.log

#!/bin/bash
# job7.sh: m5 (main 1b6461b7) and p1 (it with p1.patch: the fused sweep's census, C and X as one sweep and the interleaved
# sets) built, then three rounds on sqlite3.c and Lua: main's sets, then p1's with --fused and --interleave 1, 16, 0 and
# 256, a round's runs in two holds; and two rounds on musl of main and of p1 with --interleave 1 and 0.
set -u
cd "$(dirname "$0")"
./build-label.sh m5 1b6461b70 > results/m5-build.out 2>&1 || { echo "m5 build failed" >> results/job7.log; exit 1; }
./build-label.sh p1 1b6461b70 p1.patch > results/p1-build.out 2>&1 || { echo "p1 build failed" >> results/job7.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "m5 base" "p1 i1 --fused --interleave 1" "p1 i16 --fused --interleave 16"
    ./time-o.sh -r$round "m5 base2" "p1 i0 --fused --interleave 0" "p1 i256 --fused --interleave 256"
    echo "round $round done $(date -u +%T)" >> results/job7.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "m5 base" "p1 i1 --fused --interleave 1" "p1 i0 --fused --interleave 0"
    echo "musl round $round done $(date -u +%T)" >> results/job7.log
done
echo "job7 done $(date -u +%FT%TZ)" >> results/job7.log

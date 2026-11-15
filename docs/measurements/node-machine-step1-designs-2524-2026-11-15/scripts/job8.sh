#!/bin/bash
# job8.sh: p2 (main 1b6461b7 with p2.patch: p1 with C and X as main has them) built, then three rounds on sqlite3.c and
# Lua: main's sets (m5), then p2's with --fused and --interleave 1, 16, 0 and 256, a round's runs in two holds; and two
# rounds on musl of main and of p2 with --interleave 1 and 0.
set -u
cd "$(dirname "$0")"
./build-label.sh p2 1b6461b70 p2.patch > results/p2-build.out 2>&1 || { echo "p2 build failed" >> results/job8.log; exit 1; }
for round in 4 5 6; do
    ./time-o.sh -r$round "m5 base" "p2 i1 --fused --interleave 1" "p2 i16 --fused --interleave 16"
    ./time-o.sh -r$round "m5 base2" "p2 i0 --fused --interleave 0" "p2 i256 --fused --interleave 256"
    echo "round $round done $(date -u +%T)" >> results/job8.log
done
for round in 4 5; do
    ./time-musl-o.sh -r$round "m5 base" "p2 i1 --fused --interleave 1" "p2 i0 --fused --interleave 0"
    echo "musl round $round done $(date -u +%T)" >> results/job8.log
done
echo "job8 done $(date -u +%FT%TZ)" >> results/job8.log

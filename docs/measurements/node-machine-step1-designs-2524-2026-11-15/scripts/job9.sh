#!/bin/bash
# job9.sh: m6 (main 1b6461b7 with m6.patch: the sweeps' functions on 64-byte lines, nothing else) and p3 (main with
# p3.patch: p2 with that alignment) built, then three rounds on sqlite3.c and Lua: main's sets (m5, m6), then p3's with
# --fused and --interleave 1, 16, 0 and 256, a round's runs in two holds; and two rounds on musl of m5, m6 and p3 with
# --interleave 1 and 0.
set -u
cd "$(dirname "$0")"
./build-label.sh m6 1b6461b70 m6.patch > results/m6-build.out 2>&1 || { echo "m6 build failed" >> results/job9.log; exit 1; }
./build-label.sh p3 1b6461b70 p3.patch > results/p3-build.out 2>&1 || { echo "p3 build failed" >> results/job9.log; exit 1; }
for round in 7 8 9; do
    ./time-o.sh -r$round "m5 base" "m6 base" "p3 i1 --fused --interleave 1" "p3 i16 --fused --interleave 16"
    ./time-o.sh -r$round "m5 base2" "m6 base2" "p3 i0 --fused --interleave 0" "p3 i256 --fused --interleave 256"
    echo "round $round done $(date -u +%T)" >> results/job9.log
done
for round in 7 8; do
    ./time-musl-o.sh -r$round "m5 base" "m6 base" "p3 i1 --fused --interleave 1" "p3 i0 --fused --interleave 0"
    echo "musl round $round done $(date -u +%T)" >> results/job9.log
done
echo "job9 done $(date -u +%FT%TZ)" >> results/job9.log

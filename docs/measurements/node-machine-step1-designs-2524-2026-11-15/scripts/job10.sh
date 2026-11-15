#!/bin/bash
# job10.sh: p4 (main 1b6461b7 with p4.patch: p2 with each timed set's passes run one after another, not the sets in turn
# inside a pass) built, then three rounds on sqlite3.c and Lua: main's sets (m5), p2's and p4's with no option and p4's
# with --fused in one hold; p2's with --fused --interleave 1 and p4's with --fused and --interleave 1, 16, 0 and 256 in
# another; and two rounds on musl of m5, p2 and p4 with no option, p4 with --fused, and p2 and p4 with --fused and
# --interleave 1, and p4 with --interleave 0.
set -u
cd "$(dirname "$0")"
./build-label.sh p4 1b6461b70 p4.patch > results/p4-build.out 2>&1 || { echo "p4 build failed" >> results/job10.log; exit 1; }
for round in 10 11 12; do
    ./time-o.sh -r$round "m5 base" "p2 jn" "p4 n" "p4 f --fused"
    ./time-o.sh -r$round "p2 ji1 --fused --interleave 1" "p4 i1 --fused --interleave 1" "p4 i16 --fused --interleave 16" "p4 i0 --fused --interleave 0" "p4 i256 --fused --interleave 256"
    echo "round $round done $(date -u +%T)" >> results/job10.log
done
for round in 10 11; do
    ./time-musl-o.sh -r$round "m5 base" "p2 jn" "p4 n" "p4 f --fused" "p2 ji1 --fused --interleave 1" "p4 i1 --fused --interleave 1" "p4 i0 --fused --interleave 0"
    echo "musl round $round done $(date -u +%T)" >> results/job10.log
done
echo "job10 done $(date -u +%FT%TZ)" >> results/job10.log

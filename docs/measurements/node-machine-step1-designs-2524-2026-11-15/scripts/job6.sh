#!/bin/bash
# job6.sh: s6 (6a02a97f with s6.patch: s5 and --interleave N, the census's walk of N expressions, or a body's for 0, then
# their sweeps, the sweeps' own ticks kept apart) built, then three rounds of the shadow's sets with --fused, --lanes-t and
# --interleave 1, 4, 16, 64, 256 and 0 on sqlite3.c and Lua (a round's runs in two holds), and two rounds of 1, 16 and 0
# on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s6 6a02a97f28531d692eab94f043d9b54d6932177d s6.patch > results/s6-build.out 2>&1 || { echo "s6 build failed" >> results/job6.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s6 i1 --fused --lanes-t --interleave 1" "s6 i4 --fused --lanes-t --interleave 4" "s6 i16 --fused --lanes-t --interleave 16"
    ./time-o.sh -r$round "s6 i64 --fused --lanes-t --interleave 64" "s6 i256 --fused --lanes-t --interleave 256" "s6 i0 --fused --lanes-t --interleave 0"
    echo "round $round done $(date -u +%T)" >> results/job6.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s6 i1 --fused --lanes-t --interleave 1" "s6 i16 --fused --lanes-t --interleave 16" "s6 i0 --fused --lanes-t --interleave 0"
    echo "musl round $round done $(date -u +%T)" >> results/job6.log
done
echo "job6 done $(date -u +%FT%TZ)" >> results/job6.log

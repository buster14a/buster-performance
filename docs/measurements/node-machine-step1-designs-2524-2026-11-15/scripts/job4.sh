#!/bin/bash
# job4.sh: s4 (6a02a97f with s4.patch: s3 and the shapes' key by lanes, long shapes kept at their second expression) built,
# then three rounds of the shadow's sets with --fused and --shapes on sqlite3.c and Lua, and two rounds on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s4 6a02a97f28531d692eab94f043d9b54d6932177d s4.patch > results/s4-build.out 2>&1 || { echo "s4 build failed" >> results/job4.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s4 fs --fused --shapes"
    echo "round $round done $(date -u +%T)" >> results/job4.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s4 fs --fused --shapes"
    echo "musl round $round done $(date -u +%T)" >> results/job4.log
done
echo "job4 done $(date -u +%FT%TZ)" >> results/job4.log

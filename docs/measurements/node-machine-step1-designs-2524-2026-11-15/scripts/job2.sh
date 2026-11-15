#!/bin/bash
# job2.sh: s2 (6a02a97f with s2.patch: s1 and C and X as one sweep, --fused) built, then three rounds of the shadow's
# sets with --fused and --shapes, and with each expression's sets twice (--repeat 2), on sqlite3.c and Lua, and two rounds
# on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s2 6a02a97f28531d692eab94f043d9b54d6932177d s2.patch > results/s2-build.out 2>&1 || { echo "s2 build failed" >> results/job2.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s2 fs --fused --shapes" "s2 fs2 --fused --shapes --repeat 2"
    echo "round $round done $(date -u +%T)" >> results/job2.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s2 fs --fused --shapes"
    echo "musl round $round done $(date -u +%T)" >> results/job2.log
done
echo "job2 done $(date -u +%FT%TZ)" >> results/job2.log

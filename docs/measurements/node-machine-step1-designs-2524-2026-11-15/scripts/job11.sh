#!/bin/bash
# job11.sh: m7 (main 1b6461b7 with m7.patch: main's shadow with each timed set's passes run one after another, nothing
# else) built, then three rounds on sqlite3.c and Lua of main's sets as main times them (m5), main's with that order
# (m7) and p4's with --fused, a round's runs in one hold; and two rounds on musl of the same three.
set -u
cd "$(dirname "$0")"
./build-label.sh m7 1b6461b70 m7.patch > results/m7-build.out 2>&1 || { echo "m7 build failed" >> results/job11.log; exit 1; }
for round in 13 14 15; do
    ./time-o.sh -r$round "m5 base" "m7 n" "p4 f --fused"
    echo "round $round done $(date -u +%T)" >> results/job11.log
done
for round in 13 14; do
    ./time-musl-o.sh -r$round "m5 base" "m7 n" "p4 f --fused"
    echo "musl round $round done $(date -u +%T)" >> results/job11.log
done
echo "job11 done $(date -u +%FT%TZ)" >> results/job11.log

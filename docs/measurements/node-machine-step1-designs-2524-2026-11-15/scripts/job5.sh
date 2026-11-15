#!/bin/bash
# job5.sh: s5 (6a02a97f with s5.patch: s4 and --interleave, the census's walk between two expressions' sweeps) built, then
# three rounds of the shadow's sets with --fused, --lanes-t and --interleave on sqlite3.c and Lua, and two rounds on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s5 6a02a97f28531d692eab94f043d9b54d6932177d s5.patch > results/s5-build.out 2>&1 || { echo "s5 build failed" >> results/job5.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s5 fli --fused --lanes-t --interleave"
    echo "round $round done $(date -u +%T)" >> results/job5.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s5 fli --fused --lanes-t --interleave"
    echo "musl round $round done $(date -u +%T)" >> results/job5.log
done
echo "job5 done $(date -u +%FT%TZ)" >> results/job5.log

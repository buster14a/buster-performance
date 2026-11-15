#!/bin/bash
# job3.sh: s3 (6a02a97f with s3.patch: s2 and T's prologue by lanes, --lanes-t) built, then three rounds of the shadow's
# sets with --fused and --lanes-t, and with each expression's sets twice (--repeat 2), on sqlite3.c and Lua, and two
# rounds on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s3 6a02a97f28531d692eab94f043d9b54d6932177d s3.patch > results/s3-build.out 2>&1 || { echo "s3 build failed" >> results/job3.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s3 fl --fused --lanes-t" "s3 fl2 --fused --lanes-t --repeat 2"
    echo "round $round done $(date -u +%T)" >> results/job3.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s3 fl --fused --lanes-t"
    echo "musl round $round done $(date -u +%T)" >> results/job3.log
done
echo "job3 done $(date -u +%FT%TZ)" >> results/job3.log

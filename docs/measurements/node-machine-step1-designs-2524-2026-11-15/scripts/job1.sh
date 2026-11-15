#!/bin/bash
# job1.sh: s1 (6a02a97f with s1.patch: the census and the shapes' first prototype) built, then three rounds of the
# shadow's sets with the shapes (--shapes) and with each expression's sets twice (--repeat 2), on sqlite3.c and Lua, and
# two rounds on musl.
set -u
cd "$(dirname "$0")"
./build-label.sh s1 6a02a97f28531d692eab94f043d9b54d6932177d s1.patch > results/s1-build.out 2>&1 || { echo "s1 build failed" >> results/job1.log; exit 1; }
for round in 1 2 3; do
    ./time-o.sh -r$round "s1 sh --shapes" "s1 sh2 --shapes --repeat 2"
    echo "round $round done $(date -u +%T)" >> results/job1.log
done
for round in 1 2; do
    ./time-musl-o.sh -r$round "s1 sh --shapes"
    echo "musl round $round done $(date -u +%T)" >> results/job1.log
done
echo "job1 done $(date -u +%FT%TZ)" >> results/job1.log

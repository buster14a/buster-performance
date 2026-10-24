#!/usr/bin/env bash
# cand-7d2b2c8, and main.c across cand-5ec4653, cand-64e7910 and cand-7d2b2c8, each run under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh cand-7d2b2c8 > results/build-cand-7d2b2c8.txt 2>&1
for round in 1 2 3 4; do
    for tree in cand-5ec4653 cand-64e7910 cand-7d2b2c8; do
        ./bench.sh $tree main --only vectorized > results/ab10-main-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    ./bench.sh cand-64e7910 sqlite --only vectorized > results/ab10-sqlite-cand-64e7910-$round.txt 2>&1
    ./bench.sh cand-7d2b2c8 sqlite --only vectorized > results/ab10-sqlite-cand-7d2b2c8-$round.txt 2>&1
done
for tree in cand-5ec4653 cand-64e7910 cand-7d2b2c8; do
    ./perfstat.sh $tree main --runs 5 > results/stat10-main-$tree.txt 2>&1
done
echo done > results/queue10.done

#!/usr/bin/env bash
# cand-64e7910 against cand-5ec4653: its build, then interleaved benchmark runs, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh cand-64e7910 > results/build-cand-64e7910.txt 2>&1
for round in 1 2 3; do
    ./bench.sh cand-5ec4653 sqlite --only vectorized > results/ab8-sqlite-5ec4653-$round.txt 2>&1
    ./bench.sh cand-64e7910 sqlite --only vectorized > results/ab8-sqlite-64e7910-$round.txt 2>&1
done
for round in 1 2; do
    ./bench.sh cand-5ec4653 main --only vectorized > results/ab8-main-5ec4653-$round.txt 2>&1
    ./bench.sh cand-64e7910 main --only vectorized > results/ab8-main-64e7910-$round.txt 2>&1
done
./probe.sh cand-64e7910 sqlite --runs 21 > results/probe-cand-64e7910-sqlite.txt 2>&1
echo done > results/queue8.done

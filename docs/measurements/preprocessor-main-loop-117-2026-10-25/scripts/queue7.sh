#!/usr/bin/env bash
# cand-5ec4653 against cand-efe1e73: its build, then interleaved benchmark runs, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh cand-5ec4653 > results/build-cand-5ec4653.txt 2>&1
for round in 1 2 3; do
    ./bench.sh cand-efe1e73 sqlite --only vectorized > results/ab7-sqlite-efe1e73-$round.txt 2>&1
    ./bench.sh cand-5ec4653 sqlite --only vectorized > results/ab7-sqlite-5ec4653-$round.txt 2>&1
done
for round in 1 2; do
    ./bench.sh cand-efe1e73 main --only vectorized > results/ab7-main-efe1e73-$round.txt 2>&1
    ./bench.sh cand-5ec4653 main --only vectorized > results/ab7-main-5ec4653-$round.txt 2>&1
done
./probe.sh cand-5ec4653 sqlite --runs 21 > results/probe-cand-5ec4653-sqlite.txt 2>&1
echo done > results/queue7.done

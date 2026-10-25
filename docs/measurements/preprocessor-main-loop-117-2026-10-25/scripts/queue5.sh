#!/usr/bin/env bash
# cand-d451fe6 (the line table) against cand-efe1e73: its build, then interleaved benchmark runs, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh cand-d451fe6 > results/build-cand-d451fe6.txt 2>&1
for round in 1 2 3; do
    ./bench.sh cand-efe1e73 sqlite --only vectorized > results/ab5-sqlite-efe1e73-$round.txt 2>&1
    ./bench.sh cand-d451fe6 sqlite --only vectorized > results/ab5-sqlite-d451fe6-$round.txt 2>&1
done
./probe.sh cand-d451fe6 sqlite --runs 21 > results/probe-cand-d451fe6-sqlite.txt 2>&1
echo done > results/queue5.done

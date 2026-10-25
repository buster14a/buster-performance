#!/usr/bin/env bash
# cand-efe1e73 against main's dc8fe2e: its build, a flat profile, then interleaved benchmark runs, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh cand-efe1e73 > results/build-cand-efe1e73.txt 2>&1
./perfflat.sh cand-efe1e73 sqlite results/flat-efe1e73-sqlite --runs 101 > results/flat-efe1e73-sqlite.txt 2>&1
for round in 1 2 3; do
    ./bench.sh base-dc8fe2e sqlite --only vectorized > results/ab4-sqlite-base-$round.txt 2>&1
    ./bench.sh cand-efe1e73 sqlite --only vectorized > results/ab4-sqlite-cand-$round.txt 2>&1
done
for round in 1 2; do
    ./bench.sh base-dc8fe2e main --only vectorized > results/ab4-main-base-$round.txt 2>&1
    ./bench.sh cand-efe1e73 main --only vectorized > results/ab4-main-cand-$round.txt 2>&1
done
./probe.sh cand-efe1e73 sqlite --runs 21 > results/probe-cand-efe1e73-sqlite.txt 2>&1
echo done > results/queue4.done

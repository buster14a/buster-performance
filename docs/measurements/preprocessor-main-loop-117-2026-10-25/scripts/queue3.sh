#!/usr/bin/env bash
# The candidate cand-9aaab89 against main's dc8fe2e: its build, then interleaved benchmark runs, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
while kill -0 889272 2> /dev/null; do sleep 20; done
./build.sh cand-9aaab89 > results/build-cand-9aaab89.txt 2>&1
for round in 1 2 3; do
    ./bench.sh base-dc8fe2e sqlite --only vectorized > results/ab-sqlite-base-$round.txt 2>&1
    ./bench.sh cand-9aaab89 sqlite --only vectorized > results/ab-sqlite-cand-9aaab89-$round.txt 2>&1
done
for round in 1 2; do
    ./bench.sh base-dc8fe2e main --only vectorized > results/ab-main-base-$round.txt 2>&1
    ./bench.sh cand-9aaab89 main --only vectorized > results/ab-main-cand-9aaab89-$round.txt 2>&1
done
./probe.sh cand-9aaab89 sqlite --runs 21 > results/probe-cand-9aaab89-sqlite.txt 2>&1
echo done > results/queue3.done

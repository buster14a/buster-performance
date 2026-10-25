#!/usr/bin/env bash
# The PR's A/B: main d0a61b8 against the branch's head 59f805c on sqlite3.c and main.c (interleaved rounds), and the
# branch's history cost, each run under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
./build.sh main-d0a61b8 > results/build-main-d0a61b8.txt 2>&1
./build.sh cand-59f805c > results/build-cand-59f805c.txt 2>&1
for round in 1 2 3 4; do
    for tree in main-d0a61b8 cand-59f805c; do
        ./bench.sh $tree sqlite --only vectorized > results/ab12-sqlite-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in main-d0a61b8 cand-59f805c; do
        ./bench.sh $tree main --only vectorized > results/ab12-main-$tree-$round.txt 2>&1
    done
done
for round in 1 2; do
    ./bench.sh cand-59f805c sqlite --history-cost > results/hc12-sqlite-cand-$round.txt 2>&1
done
echo done > results/queue12.done

#!/usr/bin/env bash
# cand-7d2b2c8 on sqlite3.c: --history-cost (recording on and off), the probe with and without history, and a call-graph
# profile with the kernel's samples, each run under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
for round in 1 2 3; do
    ./bench.sh cand-7d2b2c8 sqlite --history-cost > results/hc11-sqlite-$round.txt 2>&1
done
for round in 1 2; do
    ./probe.sh cand-7d2b2c8 sqlite --runs 21 > results/probe11-history-$round.txt 2>&1
    PROBE_NO_HISTORY=1 ./probe.sh cand-7d2b2c8 sqlite --runs 21 > results/probe11-nohistory-$round.txt 2>&1
done
./perf.sh cand-7d2b2c8 sqlite results/cg11 --runs 12 > results/cg11.log 2>&1
echo done > results/queue11.done

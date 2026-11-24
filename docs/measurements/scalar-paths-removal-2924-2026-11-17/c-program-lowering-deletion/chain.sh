#!/bin/bash
# One locked run at a time for this session (#2924's coordinator, 2026-11-23): pieces (a), (b) and (c)'s deletion runs in
# turn, then (d)'s benchmarks. Each run.sh holds the lock per command.
B=~/buster-fast-bench/2924-program
while pgrep -f "2924-program/a/run.sh|run.sh 0fd0634cb" > /dev/null; do sleep 30; done
(cd $B/b && ./run.sh a84f46f98 bef8f7e0f all > run.out 2>&1)
(cd $B/c && ./run.sh 272844c6c 3e44732ad all > run.out 2>&1)
(cd $B/d && ./time.sh > run.out 2>&1)

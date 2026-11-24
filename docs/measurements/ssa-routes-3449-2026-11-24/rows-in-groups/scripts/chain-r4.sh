#!/bin/bash
# chain-r4.sh: #3449 PR 1's gate: rows in column groups (rhead6) against rbase2, with construction ticks.
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > r4.log
./build2.sh rhead6 c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks2.patch $D/p-rename4.patch >> r4.log 2>&1 || { echo "head build failed" >> r4.log; exit 1; }
./gate3.sh r4 7 rbase2:0 rhead6:0 >> r4.log 2>&1
echo "end $(date -u +%T)" >> r4.log

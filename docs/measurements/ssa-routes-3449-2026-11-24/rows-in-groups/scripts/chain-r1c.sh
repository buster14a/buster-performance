#!/bin/bash
# chain-r1.sh: #3449 PR 1's gate: base (main c61e37a1 + ticks) and head (+ the renaming), one locked run at a time.
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > r1.log
./build2.sh rbase c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks.patch >> r1.log 2>&1 || { echo "base build failed" >> r1.log; exit 1; }
./build2.sh rhead c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks.patch $D/p-rename.patch >> r1.log 2>&1 || { echo "head build failed" >> r1.log; exit 1; }
./gate3.sh r1 7 rbase:0 rhead:0 >> r1.log 2>&1
echo "end $(date -u +%T)" >> r1.log

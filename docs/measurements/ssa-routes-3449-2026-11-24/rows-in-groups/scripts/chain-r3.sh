#!/bin/bash
# chain-r3.sh: #3449 PR 1's gate with construction ticks: base, head (chunked renaming), head with the scan and walk noinline.
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > r3.log
./build2.sh rbase2 c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks2.patch >> r3.log 2>&1 || { echo "base build failed" >> r3.log; exit 1; }
./build2.sh rhead4 c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks2.patch $D/p-rename2.patch >> r3.log 2>&1 || { echo "head build failed" >> r3.log; exit 1; }
./build2.sh rhead5 c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks2.patch $D/p-rename3.patch >> r3.log 2>&1 || { echo "head5 build failed" >> r3.log; exit 1; }
./gate3.sh r3 7 rbase2:0 rhead4:0 rhead5:0 >> r3.log 2>&1
echo "end $(date -u +%T)" >> r3.log

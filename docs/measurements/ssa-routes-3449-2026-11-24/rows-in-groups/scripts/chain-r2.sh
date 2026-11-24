#!/bin/bash
# chain-r2.sh: #3449 PR 1's gate, chunked renaming: head2 (main + ticks + renaming in chunks) against rbase.
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > r2.log
./build2.sh rhead2 c61e37a11447e379f959c396b6d7abd2c99516f4 $D/p-ticks.patch $D/p-rename2.patch >> r2.log 2>&1 || { echo "head build failed" >> r2.log; exit 1; }
./gate3.sh r2 7 rbase:0 rhead2:0 >> r2.log 2>&1
echo "end $(date -u +%T)" >> r2.log

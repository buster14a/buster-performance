#!/bin/bash
# chain-c1.sh: #3449 piece 2's gate: crows (#3511's head + ticks) against ccap (+ the dense storage bound without cells),
# with a control copy of crows; objects differ where the 7 formerly bounded functions are.
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > c1.log
./build2.sh crows 9c49d771e6e070505213dcb998e9658fe82a68be $D/p-ticks3.patch >> c1.log 2>&1 || { echo "rows build failed" >> c1.log; exit 1; }
./build2.sh ccap 8a0b2b3bce6bd0ce415f336b51c89726f1ceed0e $D/p-ticks3.patch >> c1.log 2>&1 || { echo "cap build failed" >> c1.log; exit 1; }
cp compiler-crows compiler-crowsc
./gate3.sh c1 7 crows:0 ccap:0 crowsc:0 >> c1.log 2>&1
echo "end $(date -u +%T)" >> c1.log

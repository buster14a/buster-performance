#!/bin/bash
# chain-r7.sh: #3449 PR 1's gate again with a control: rbase2, rhead8 and rbase2c (a copy of rbase2's file).
D=~/buster-fast-bench/2924-c9h
cd $D
echo "start $(date -u +%T)" > r7.log
cp compiler-rbase2 compiler-rbase2c
./gate3.sh r7 7 rbase2:0 rhead8:0 rbase2c:0 >> r7.log 2>&1
echo "end $(date -u +%T)" >> r7.log

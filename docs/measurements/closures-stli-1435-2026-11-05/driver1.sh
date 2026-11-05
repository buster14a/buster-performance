#!/usr/bin/env bash
# 1435 driver: the 8-shift timing of main, pad0, pad8 and pad0w; the link orders; the front-end counters. Each script's
# runs take the lock one at a time.
set -u
W=$HOME/buster-fast-bench/1435-claude
cd $W || exit 1
TAG=2 SHIFTS="0 16 32 48 64 80 96 112" BUILDS="main pad0 pad8 pad0w" ROUNDS=11 ./padtime.sh > padtime2.out 2>&1
./orders.sh > orders.out 2>&1
./fecount.sh > fecount.out 2>&1
echo done > driver1.done

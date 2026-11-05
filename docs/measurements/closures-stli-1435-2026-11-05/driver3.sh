#!/usr/bin/env bash
# 1435 driver 3: 33 link orders (0 the usual one, 1 to 32 random), 3 rounds each, main, pad0 and pad0w.
set -u
W=$HOME/buster-fast-bench/1435-claude
cd $W || exit 1
until [ -f driver2.done ] && [ -f fetch/done-p0.txt ]; do sleep 30; done
TAG=2 ORDERS=33 ROUNDS=3 BUILDS="main pad0 pad0w" ./orders.sh > orders2.out 2>&1
echo done > driver3.done

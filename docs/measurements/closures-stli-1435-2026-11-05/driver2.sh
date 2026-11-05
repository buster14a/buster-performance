#!/usr/bin/env bash
# 1435 driver 2: IBS at stack positions of high and low STLI (envsweep): main at k 0 (5.1M) and 2 (1.4M), head at k 68
# (6.9M) and 64 (1.7M), 30 runs each.
set -u
W=$HOME/buster-fast-bench/1435-claude
cd $W || exit 1
until [ -f driver1.done ]; do sleep 30; done
RUNS=30 BUILDS=main ./ibs-rec.sh 0 k0b > ibs-rec2.out 2>&1
RUNS=30 BUILDS=main ./ibs-rec.sh 2 k2 >> ibs-rec2.out 2>&1
RUNS=30 BUILDS=head ./ibs-rec.sh 68 k68 >> ibs-rec2.out 2>&1
RUNS=30 BUILDS=head ./ibs-rec.sh 64 k64 >> ibs-rec2.out 2>&1
echo done > driver2.done

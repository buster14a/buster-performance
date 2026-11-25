#!/bin/bash
# #3592's step 6d: a placement control for sqlite3.c. atom1 (step 6c's head) and dead1 (step 6d's), each with 64,
# 1,500 and 4,000 bytes of nops ahead of the code generator (padN.patch); each build under the lock on its own, then
# sqlite3.c's A/B and stages over the eight variants in one hold each.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: dead arms (#3592 step 6d), placement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
for arm in atom1 dead1; do
  for n in 64 1500 4000; do
    X timeout -k 5 1200 ./build-variant.sh $arm-p$n $arm.patch pad$n.patch
  done
done
names="atom1 dead1 atom1-p64 dead1-p64 atom1-p1500 dead1-p1500 atom1-p4000 dead1-p4000"
for n in $names; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-pads.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="sqlite" ./ab.sh 21 $names > results/ab-pads.txt 2> results/ab-pads.err
X timeout -k 5 900 ./stages.sh 21 $names > results/stages-pads.txt 2> results/stages-pads.err
echo done > results/job-pads.done

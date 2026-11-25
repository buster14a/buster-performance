#!/bin/bash
# #3592's step 6d with its rare paths out of the hot functions (dead2): sqlite3.c against step 6c's head, both also
# with 1,500 bytes of nops ahead of the code generator. Each build under the lock on its own, then the A/B and stages
# over the variants in one hold each.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: dead arms (#3592 step 6d), cold paths" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh dead2 dead2.patch
X timeout -k 5 1200 ./build-variant.sh dead2-p1500 dead2.patch pad1500.patch
names="atom1 dead1 dead2 atom1-p1500 dead2-p1500"
for n in $names; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-dead2.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="six hello sqlite" ./ab.sh 21 $names > results/ab-dead2.txt 2> results/ab-dead2.err
X timeout -k 5 900 ./stages.sh 21 $names > results/stages-dead2.txt 2> results/stages-dead2.err
echo done > results/job-dead2.done

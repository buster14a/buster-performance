#!/bin/bash
# #3592's step 6d: where sqlite3.c's code generator loses its 0.1 ms. atom1-fix is step 6c's head with #3616's
# fval_release change alone; dead1-nofix is step 6d's head without it; dead1-alt is step 6d's head with #3616 fixed
# by keeping the registers where code stops instead (alt-registers.patch). Each build under the lock on its own, then
# sqlite3.c's A/B and stages over the five in one hold each.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: dead arms (#3592 step 6d), split" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
[ -x bin/compiler-atom1-fix ] || X timeout -k 5 1200 ./build-variant.sh atom1-fix atom1.patch fix.patch
[ -x bin/compiler-dead1-nofix ] || X timeout -k 5 1200 ./build-variant.sh dead1-nofix dead1nofix.patch
X timeout -k 5 1200 ./build-variant.sh dead1-alt dead1alt.patch
names="atom1 dead1 atom1-fix dead1-nofix dead1-alt"
for n in $names; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-split.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="sqlite" ./ab.sh 21 $names > results/ab-split.txt 2> results/ab-split.err
X timeout -k 5 900 ./stages.sh 21 $names > results/stages-split.txt 2> results/stages-split.err
echo done > results/job-split.done

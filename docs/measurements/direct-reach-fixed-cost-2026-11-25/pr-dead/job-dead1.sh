#!/bin/bash
# #3592's step 6d (dead arms, dead1) against step 6c's head (atom1): one build, then each measurement under the lock on
# its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: dead arms (#3592 step 6d), A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh dead1 dead1.patch
for n in atom1 dead1; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-dead1.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="six hello sqlite" ./ab.sh 21 atom1 dead1 > results/ab-dead1.txt 2> results/ab-dead1.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 7 atom1 dead1 > results/builds-c99-dead1.txt 2> results/builds-c99-dead1.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 7 atom1 dead1 > results/builds-gnu-dead1.txt 2> results/builds-gnu-dead1.err
echo done > results/job-dead1.done

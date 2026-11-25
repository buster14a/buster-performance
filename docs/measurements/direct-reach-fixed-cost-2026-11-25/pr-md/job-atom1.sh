#!/bin/bash
# #3592's step 6c (musl's atomics' inline asm, atom1) against the -MD step's head (md2): one build, then each
# measurement under the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: musl's atomics (#3592 step 6c), A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh atom1 atom1.patch
for n in md2 atom1; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-atom1.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="six hello sqlite" ./ab.sh 21 md2 atom1 > results/ab-atom1.txt 2> results/ab-atom1.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 7 md2 atom1 > results/builds-c99-atom1.txt 2> results/builds-c99-atom1.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 7 md2 atom1 > results/builds-gnu-atom1.txt 2> results/builds-gnu-atom1.err
echo done > results/job-atom1.done

#!/bin/bash
# #3592's dependency files (-MD and its kin) on the direct path, and -H off it (#3612), against #3607's head (asm6d):
# one build, then each measurement under the lock on its own, plain and with -MD.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: -MD and its kin (#3592), A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh md1 md1.patch
for n in asm6d md1; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-md1.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="six hello sqlite" ./ab.sh 21 asm6d md1 > results/ab-md1.txt 2> results/ab-md1.err
X timeout -k 5 900 env AB_UNITS="six hello sqlite" AB_FLAGS=-MD ./ab.sh 21 asm6d md1 > results/ab-md1-deps.txt 2> results/ab-md1-deps.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 asm6d md1 > results/builds-c99-md1.txt 2> results/builds-c99-md1.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl DEP_FLAGS=-MD ./builds-ab.sh 5 asm6d md1 > results/builds-c99-md1-deps.txt 2> results/builds-c99-md1-deps.err
X timeout -k 5 900 env BUILDS=lua ./builds-ab.sh 5 asm6d md1 > results/builds-lua-md1.txt 2> results/builds-lua-md1.err
X timeout -k 5 900 env BUILDS=lua DEP_FLAGS=-MD ./builds-ab.sh 5 asm6d md1 > results/builds-lua-md1-deps.txt 2> results/builds-lua-md1-deps.err
echo done > results/job-md1.done

#!/bin/bash
# buster#3600/#3603's fix with its scan compiled once for each mode, and step 6b (musl's inline asm) on it, against #3602's head:
# two builds, then each measurement under the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: raw strings (#3600) and step 6b (#3592), A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh pr3600c pr3600c.patch
X timeout -k 5 1200 ./build-variant.sh asm6c asm6c.patch
for n in pr3600c asm6c; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-pr3600c.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="add hello sqlite" ./ab.sh 21 pr3599v2 pr3600c asm6c > results/ab-pr3600c.txt 2> results/ab-pr3600c.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 pr3599v2 pr3600c asm6c > results/builds-c99-pr3600c.txt 2> results/builds-c99-pr3600c.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 5 pr3599v2 pr3600c asm6c > results/builds-gnu-pr3600c.txt 2> results/builds-gnu-pr3600c.err
echo done > results/job-pr3600c.done

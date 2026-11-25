#!/bin/bash
# The PR of #3592's steps 4 and 6a and #3599's fix against main (20f3573ee), with step 6a's binary between: each
# build and each measurement takes the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: #3592 steps 4 and 6a with #3599, final A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3599 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh main20f main20f.patch
X timeout -k 5 1200 ./build-variant.sh pr3599 pr3599.patch
for n in main20f pr3599; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-pr3599.done; exit 1; }; done
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 main20f a6 pr3599 > results/builds-c99-pr3599.txt 2> results/builds-c99-pr3599.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 5 main20f a6 pr3599 > results/builds-gnu-pr3599.txt 2> results/builds-gnu-pr3599.err
X timeout -k 5 900 env AB_UNITS="add hello sqlite" ./ab.sh 11 main20f a6 pr3599 > results/ab-pr3599.txt 2> results/ab-pr3599.err
echo done > results/job-pr3599.done

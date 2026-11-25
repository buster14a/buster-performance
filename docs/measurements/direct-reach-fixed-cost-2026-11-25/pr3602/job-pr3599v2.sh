#!/bin/bash
# The #3599 fix's second form (switch-shaped specifier chains) against main, step 6a and its first form: one build, then
# each measurement under the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: #3599's specifier chains, A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3602 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh pr3599v2 pr3599v2.patch
./bin/compiler-pr3599v2 --version > /dev/null || { echo "compiler-pr3599v2 doesn't run" > results/job-pr3599v2.done; exit 1; }
X timeout -k 5 900 env AB_UNITS="add hello sqlite" ./ab.sh 21 main20f a6 pr3599 pr3599v2 > results/ab-pr3599v2.txt 2> results/ab-pr3599v2.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 a6 pr3599 pr3599v2 > results/builds-c99-pr3599v2.txt 2> results/builds-c99-pr3599v2.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 5 main20f a6 pr3599v2 > results/builds-gnu-pr3599v2.txt 2> results/builds-gnu-pr3599v2.err
echo done > results/job-pr3599v2.done

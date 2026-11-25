#!/bin/bash
# buster#3600 and #3603's fix (raw string literals; a directive's rest) against #3602's head: one build, then each
# measurement under the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: raw strings and a directive's rest (#3600, #3603), A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3600 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh pr3600 pr3600.patch
./bin/compiler-pr3600 --version > /dev/null || { echo "compiler-pr3600 doesn't run" > results/job-pr3600.done; exit 1; }
X timeout -k 5 900 env AB_UNITS="add hello sqlite" ./ab.sh 21 pr3599v2 pr3600 > results/ab-pr3600.txt 2> results/ab-pr3600.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 5 pr3599v2 pr3600 > results/builds-gnu-pr3600.txt 2> results/builds-gnu-pr3600.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 pr3599v2 pr3600 > results/builds-c99-pr3600.txt 2> results/builds-c99-pr3600.err
echo done > results/job-pr3600.done

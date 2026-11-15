#!/bin/bash
# job1.sh: m8 (main b9ebe041) and e1 (it with e1.patch: TSC ticks around the coded walk's flushes and their sizes) built,
# then -c sqlite3.c seven times each, the two in turn, in one hold.
set -u
cd "$(dirname "$0")"
./build-label.sh m8 b9ebe0415 > results/m8-build.out 2>&1 || { echo "m8 build failed" >> results/job1.log; exit 1; }
./build-label.sh e1 b9ebe0415 e1.patch > results/e1-build.out 2>&1 || { echo "e1 build failed" >> results/job1.log; exit 1; }
./walk-o.sh -a 7 m8 e1
echo "job1 done $(date -u +%FT%TZ)" >> results/job1.log

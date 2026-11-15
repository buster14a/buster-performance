#!/bin/bash
# stores.sh [records] [passes]: tools/stores.c built (clang -O3 -march=native) and run on CPU 2 under the lock;
# results/stores-RECORDS.txt.
set -u
cd "$(dirname "$0")"
records=${1:-1024}; passes=${2:-20000}
mkdir -p results
clang -O3 -march=native -Wall -o tools/stores tools/stores.c || exit 1
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-120; cat /proc/loadavg; taskset -c 2 tools/stores $records $passes; cat /proc/loadavg" > results/stores-$records.txt 2>&1
cat results/stores-$records.txt

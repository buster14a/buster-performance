#!/bin/bash
# run-all.sh: main f006224e, the fold alone (fold-v1.diff) and the fold with the loop's increment (fold-v2.diff), each
# built in one hold; the comparison (corpora.sh) on main and v2; the timing (time.sh) on all three, then twice more in
# turn (main, v1, v2), each run in a hold of the lock of its own.
set -u
cd "$(dirname "$0")"
./build-tree.sh main main || exit 1
./apply.sh fold-v1.diff > results-apply-v1.txt 2>&1 || exit 1
./build-tree.sh src v1 || exit 1
./apply.sh fold-v2.diff > results-apply-v2.txt 2>&1 || exit 1
./build-tree.sh src v2 || exit 1
./corpora.sh main
./corpora.sh v2
for round in 1 2 3; do
    for label in main v1 v2; do
        ./time.sh "$label-time$round" "$label"
    done
done
date -u +%FT%TZ > results/.all

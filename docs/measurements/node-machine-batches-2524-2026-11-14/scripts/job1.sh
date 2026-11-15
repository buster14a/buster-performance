#!/bin/bash
# job1.sh: builds main (m3, bb754cb8) and the batching commit (b1, 5d4c533), then three rounds of time-batch.sh: m3
# without --batch and b1 at batches 1 to 1024, each run its own hold of the lock.
set -u
cd "$(dirname "$0")"
./build-label.sh m3 bb754cb80 > results/m3-build.out 2>&1
./build-label.sh b1 5d4c533 > results/b1-build.out 2>&1
for round in 1 2 3; do
    ./time-batch.sh m3 - -r$round
    for b in 1 2 4 8 16 32 64 256 1024; do
        ./time-batch.sh b1 $b -r$round
    done
done
date -u +%FT%TZ > results/.job1-done

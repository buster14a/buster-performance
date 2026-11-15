#!/bin/bash
# job6.sh: builds a50a228 (b2: T by batches, C and X an expression at a time), then three rounds of time-g.sh, each one
# hold: main (m3) without --batch and b2 at batches 1, 16, 64, 256 and 1024.
set -u
cd "$(dirname "$0")"
./build-label.sh b2 a50a228 > results/b2-build.out 2>&1
for round in 1 2 3; do
    ./time-g.sh -r$round m3:- b2:1 b2:16 b2:64 b2:256 b2:1024
done
date -u +%FT%TZ > results/.job6-done

#!/bin/bash
# job2.sh: main and the batching commit with their only patches (m3o, b1o), then counts-b.sh on sqlite3.c: m3o without
# --batch, b1o at batches 1, 16 and 256.
set -u
cd "$(dirname "$0")"
./build-label.sh m3o bb754cb80 only-m.patch > results/m3o-build.out 2>&1
./build-label.sh b1o 5d4c533 only-b.patch > results/b1o-build.out 2>&1
./counts-b.sh m3o -
for b in 1 16 256; do ./counts-b.sh b1o $b; done
date -u +%FT%TZ > results/.job2-done

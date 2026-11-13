#!/bin/bash
# run-v6.sh REVISION: v6 built, then timed in turn with main (m2), four rounds (each run in a hold of its own), then
# profiled by instructions and by cycles.
set -u
cd "$(dirname "$0")"
./build.sh v6 "$1"
for k in 1 2 3 4; do
    ./time.sh v6 -f$k
    ./time.sh m2 -f$((k + 1))
done
./annotate2.sh v6 instructions:u
./annotate2.sh v6 cycles:u
date -u +%FT%TZ > results/.run-v6-done

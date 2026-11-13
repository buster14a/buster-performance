#!/bin/bash
# run-v7.sh REVISION: after run-v6.sh, v7 built, then v7, v6 and main (m2) timed in turn, four rounds (each run in a hold
# of its own), then v7 profiled by instructions and by cycles.
set -u
cd "$(dirname "$0")"
while pgrep -f '^/bin/bash ./run-v6.sh' > /dev/null; do sleep 10; done
./build.sh v7 "$1"
for k in 1 2 3 4; do
    ./time.sh v7 -f$k
    ./time.sh v6 -f$((k + 4))
    ./time.sh m2 -f$((k + 5))
done
./annotate2.sh v7 instructions:u
./annotate2.sh v7 cycles:u
date -u +%FT%TZ > results/.run-v7-done

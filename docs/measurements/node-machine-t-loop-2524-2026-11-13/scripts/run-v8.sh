#!/bin/bash
# run-v8.sh: after run-v7.sh, main with v8a.patch (each operand found from the record's node) and with v8b.patch (each
# function's columns through a local base) built, then v8a, v8b and main (m2) timed in turn, four rounds (each run in a
# hold of its own), then both profiled by instructions.
set -u
cd "$(dirname "$0")"
while pgrep -f '^/bin/bash ./run-v7.sh' > /dev/null; do sleep 10; done
./build-patch.sh v8a 26f0bb0e1 v8a.patch
./build-patch.sh v8b 26f0bb0e1 v8b.patch
for k in 1 2 3 4; do
    ./time.sh v8a -f$k
    ./time.sh v8b -f$k
    ./time.sh m2 -f$((k + 9))
done
./annotate2.sh v8a instructions:u
./annotate2.sh v8b instructions:u
date -u +%FT%TZ > results/.run-v8-done

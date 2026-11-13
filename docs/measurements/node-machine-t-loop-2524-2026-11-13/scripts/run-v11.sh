#!/bin/bash
# run-v11.sh REVISION: v11 (main with the columns' local base and the operands from the node, no callee memo) built, then
# v11, v10 and main (m2) timed in turn, five rounds (each run in a hold of its own), then v11 profiled by instructions and
# by cycles, checked on the corpora, and -c sqlite3.c by v11 compared with main's.
set -u
cd "$(dirname "$0")"
./build.sh v11 "$1"
for k in 1 2 3 4 5; do
    ./time.sh v11 -f$k
    ./time.sh v10 -f$((k + 4))
    ./time.sh m2 -f$((k + 17))
done
./annotate2.sh v11 instructions:u
./annotate2.sh v11 cycles:u
./corpora.sh v11
./ab.sh m2 v11
date -u +%FT%TZ > results/.run-v11-done

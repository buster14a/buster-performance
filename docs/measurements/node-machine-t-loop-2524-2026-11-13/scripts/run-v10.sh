#!/bin/bash
# run-v10.sh V9REVISION V10REVISION: v9 (the callee memo) and v10 (with the columns' local base and the operands from the
# node) built, then v10, v9 and main (m2) timed in turn, four rounds (each run in a hold of its own), then v10 profiled by
# instructions and by cycles, checked on the corpora, and -c sqlite3.c by v10 compared with main's.
set -u
cd "$(dirname "$0")"
./build.sh v9 "$1"
./build.sh v10 "$2"
for k in 1 2 3 4; do
    ./time.sh v10 -f$k
    ./time.sh v9 -f$k
    ./time.sh m2 -f$((k + 13))
done
./annotate2.sh v10 instructions:u
./annotate2.sh v10 cycles:u
./corpora.sh v10
./ab.sh m2 v10
date -u +%FT%TZ > results/.run-v10-done

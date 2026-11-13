#!/bin/bash
# run-v45.sh V4REVISION V5REVISION V3PID: after run-v3.sh (its PID), v4 and v5 built, then v5, v4, v3 and main timed in
# turn, four rounds (each run in a hold of its own), then v5 profiled and checked on the corpora, and -c sqlite3.c by v5
# compared with main's.
set -u
cd "$(dirname "$0")"
while kill -0 "$3" 2>/dev/null; do sleep 10; done
./build.sh v4 "$1"
./build.sh v5 "$2"
for k in 1 2 3 4; do
    ./time.sh v5 -f$k
    ./time.sh v4 -f$k
    ./time.sh v3 -f$((k + 5))
    ./time.sh main -f$((k + 12))
done
./profile.sh v5
./annotate.sh v5
./corpora.sh v5
./ab.sh main v5
date -u +%FT%TZ > results/.run-v45-done

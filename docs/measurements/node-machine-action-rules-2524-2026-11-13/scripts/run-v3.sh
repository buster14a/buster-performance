#!/bin/bash
# run-v3.sh REVISION V1PID: after run-v1.sh (its PID), v3 built, then timed alternating with main (each in a hold of its
# own), profiled, checked on the corpora (main too), and -c sqlite3.c compared with main's.
set -u
cd "$(dirname "$0")"
while kill -0 "$2" 2>/dev/null; do sleep 10; done
./build.sh v3 "$1"
for k in 1 2 3 4 5; do
    ./time.sh v3 -f$k
    ./time.sh main -f$((k + 7))
done
./profile.sh v3
./annotate.sh v3
./corpora.sh v3
./corpora.sh main
./ab.sh main v3
date -u +%FT%TZ > results/.run-v3-done

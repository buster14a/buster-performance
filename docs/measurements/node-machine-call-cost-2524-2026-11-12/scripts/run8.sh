#!/bin/bash
# run8.sh MAIN HEAD: the record again after main took the increments and compound assignments (#2577): main2 (the pull
# request's new parent) and head2 (the branch with it merged) built, head2's corpora compared, both timed ten times
# alternating (suffixes -f1 to -f10), both profiled, and -c sqlite3.c's A/B; each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh main2 "$1"
./build.sh head2 "$2"
./corpora.sh head2
for k in 1 2 3 4 5 6 7 8 9 10; do
    ./time.sh main2 -f$k
    ./time.sh head2 -f$k
done
./profile.sh main2
./profile.sh head2
./ab.sh main2 head2
python3 medians.py results main2 head2 > results/medians-main2-head2.txt
date -u +%FT%TZ > results/.run8-done

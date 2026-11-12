#!/bin/bash
# run9.sh MAIN HEAD: the record again after main took T's records as columns (#2580): main3 (the pull
# request's new parent) and head3 (the branch with it merged) built, head3's corpora compared, both timed ten times
# alternating (suffixes -f1 to -f10), both profiled, and -c sqlite3.c's A/B; each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh main3 "$1"
./build.sh head3 "$2"
./corpora.sh head3
for k in 1 2 3 4 5 6 7 8 9 10; do
    ./time.sh main3 -f$k
    ./time.sh head3 -f$k
done
./profile.sh main3
./profile.sh head3
./ab.sh main3 head3
python3 medians.py results main3 head3 > results/medians-main3-head3.txt
date -u +%FT%TZ > results/.run9-done

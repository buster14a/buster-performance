#!/bin/bash
# run7.sh MAIN HEAD: the record again after main took the split, the calls, &&, || and ?: and the baked tables: main (the
# pull request's parent) and the merged head built, the head's corpora compared, both timed ten times alternating
# (suffixes -f1 to -f10), both profiled, and -c sqlite3.c's A/B; each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh main "$1"
./build.sh head "$2"
./corpora.sh head
for k in 1 2 3 4 5 6 7 8 9 10; do
    ./time.sh main -f$k
    ./time.sh head -f$k
done
./profile.sh main
./profile.sh head
./ab.sh main head
date -u +%FT%TZ > results/.run7-done

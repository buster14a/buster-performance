#!/bin/bash
# run5.sh: the record's runs at v3, each step in a hold of its own: the corpora compared with --verify (with and without
# -g), the parent and v3 timed three times each, alternating (suffixes -f1 to -f3), v3 profiled, and -c sqlite3.c's A/B.
set -u
cd "$(dirname "$0")"
./corpora.sh v3
for k in 1 2 3; do
    ./time.sh parent -f$k
    ./time.sh v3 -f$k
done
./profile.sh v3
./ab.sh parent v3
date -u +%FT%TZ > results/.run5-done

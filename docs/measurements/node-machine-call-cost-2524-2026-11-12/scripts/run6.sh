#!/bin/bash
# run6.sh: the parent and v3 timed seven more times each, alternating (suffixes -f4 to -f10), each run in a hold of its own.
set -u
cd "$(dirname "$0")"
for k in 4 5 6 7 8 9 10; do
    ./time.sh parent -f$k
    ./time.sh v3 -f$k
done
date -u +%FT%TZ > results/.run6-done

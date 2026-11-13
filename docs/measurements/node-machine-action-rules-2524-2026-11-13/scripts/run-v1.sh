#!/bin/bash
# run-v1.sh REVISION: v1 built, then timed alternating with main (each in a hold of its own), profiled and checked on the
# corpora.
set -u
cd "$(dirname "$0")"
./build.sh v1 "$1"
for k in 1 2 3 4 5; do
    ./time.sh v1 -f$k
    ./time.sh main -f$((k + 2))
done
./profile.sh v1
./annotate.sh v1
./corpora.sh v1
date -u +%FT%TZ > results/.run-v1-done

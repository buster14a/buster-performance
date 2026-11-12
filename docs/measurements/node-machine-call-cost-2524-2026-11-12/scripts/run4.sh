#!/bin/bash
# run4.sh REVISION: the third version built, then timed three times, alternating with the second, each step in a hold of
# its own.
set -u
cd "$(dirname "$0")"
./build.sh v3 "$1"
./time.sh v3
./time.sh v2 -4
./time.sh v3 -2
./time.sh v2 -5
./time.sh v3 -3
date -u +%FT%TZ > results/.run4-done

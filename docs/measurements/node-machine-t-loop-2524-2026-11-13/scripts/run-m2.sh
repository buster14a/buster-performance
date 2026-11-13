#!/bin/bash
# run-m2.sh REVISION: main built (m2), then timed and profiled by instructions and by cycles, each in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh m2 "$1"
./time.sh m2 -f1
./annotate2.sh m2 instructions:u
./annotate2.sh m2 cycles:u
date -u +%FT%TZ > results/.run-m2-done

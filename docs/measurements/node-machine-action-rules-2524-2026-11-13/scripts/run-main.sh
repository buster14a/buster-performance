#!/bin/bash
# run-main.sh REVISION: main built, then timed (twice) and profiled, each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh main "$1"
./time.sh main -f1
./profile.sh main
./annotate.sh main
./time.sh main -f2
date -u +%FT%TZ > results/.run-main-done

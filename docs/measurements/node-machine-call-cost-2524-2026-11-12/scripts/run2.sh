#!/bin/bash
# run2.sh REVISION: the second version built and timed, then the parent timed again, each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh v2 "$1"
./time.sh v2
./time.sh parent -2
date -u +%FT%TZ > results/.run2-done

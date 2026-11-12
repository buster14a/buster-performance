#!/bin/bash
# run1.sh REVISION: the first version built and timed with the parent, each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./build.sh v1 "$1"
./time.sh parent
./time.sh v1
date -u +%FT%TZ > results/.run1-done

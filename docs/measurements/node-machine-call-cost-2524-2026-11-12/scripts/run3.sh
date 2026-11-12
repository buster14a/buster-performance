#!/bin/bash
# run3.sh: v1 and v2 timed twice more, alternating, then v2 and the parent profiled, each step in a hold of its own.
set -u
cd "$(dirname "$0")"
./time.sh v1 -2
./time.sh v2 -2
./time.sh v1 -3
./time.sh v2 -3
./profile.sh v2
./profile.sh parent
date -u +%FT%TZ > results/.run3-done

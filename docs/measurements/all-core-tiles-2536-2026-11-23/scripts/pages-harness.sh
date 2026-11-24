#!/bin/bash
# run.sh LANE_C_PATH: builds the harness against a copy of lane.c and runs it.
S=/tmp/claude-0/-home-user/c5559a1a-e340-5109-8d23-d5a8ff5725f9/scratchpad
cd /home/user/buster
clang -std=gnu2x -O1 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Isrc -DLANE_C="\"$1\"" -Wall -Werror -Wno-unused-function -o $S/harness/lane_medium $S/harness/lane_medium.c -lpthread 2> $S/harness/build.err || { echo "NOT-BUILT"; head -3 $S/harness/build.err; exit 2; }
$S/harness/lane_medium

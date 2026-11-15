#!/bin/bash
# build-pad.sh TREE NAME: the tree's Release executable linked with main.c padded by 0, 16, 32 and 48 bytes (sub-line
# placements), into placements/NAME (inside the lock), as the 9700X job builds it.
set -u
d=$HOME/buster-fast-bench/2559-step5b-claude
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0
cd "$d/$1" || exit 2
mkdir -p "$d/placements/$2"
./build.sh shifts --config Release --jobs 8 "$d/placements/$2" ${3:-main.c} 0 16 32 48 > "$d/logs/build-$2.log" 2>&1

#!/bin/bash
# round6.sh: build main 9a74fc37 and the dropped ranges' fix d0ba7a5f (a hold each), then objects.sh and ab.sh on them.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh main-9a74fc37
./build.sh head-d0ba7a5f
./objects.sh main-9a74fc37 head-d0ba7a5f obj6
./ab.sh main-9a74fc37 head-d0ba7a5f ab6
echo round6-done

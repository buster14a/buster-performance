#!/bin/bash
# round7.sh: build main a4a2182a and the #1167 head 5550ad48 (a hold each), then objects.sh and ab.sh on them.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh main-a4a2182a
./build.sh head-5550ad48
./objects.sh main-a4a2182a head-5550ad48 obj7
./ab.sh main-a4a2182a head-5550ad48 ab7
echo round7-done

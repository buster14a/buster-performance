#!/bin/bash
# round5.sh: build main 703ae9f5 and the #1167 head 49f066ba (a hold each), then objects.sh and ab.sh on them.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh main-703ae9f5
./build.sh head-49f066ba
./objects.sh main-703ae9f5 head-49f066ba obj5
./ab.sh main-703ae9f5 head-49f066ba ab5
echo round5-done

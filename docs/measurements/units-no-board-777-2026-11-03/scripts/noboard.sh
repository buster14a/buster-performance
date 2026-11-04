#!/bin/bash
# The no-board fix (claude/777-no-board): ab.sh of main a4a2182a against 70f0e5e3, then the head's test-check-units.
set -u
W=$HOME/buster-fast-bench/777-claude
cd $W
uname -a; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
./ab.sh noboard 21 tree-a4a2182a tree-70f0e5e3
cd $W/tree-70f0e5e3
EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" TMPDIR=$W/tmp ~/buster-fast-bench/exclusive.sh ./build/compiler test-check-units > $W/noboard-units.log 2>&1
echo "test-check-units status $?"; tail -2 $W/noboard-units.log; grep -n "shared parts" $W/noboard-units.log
echo noboard-finished

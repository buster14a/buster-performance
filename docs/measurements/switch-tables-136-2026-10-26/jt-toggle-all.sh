#!/bin/bash
# Builds the switched tree (jump-136-toggle) under its own hold of the lock, then runs jump-136-toggle.sh.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
B=~/buster-fast-bench
cd $B/jump-136-toggle || exit 1
BUSTER_DEBUG_INFO=0 $B/exclusive.sh ./build.sh > build.log 2>&1
status=$?
tail -1 build.log
echo "build status $status"
[ $status = 0 ] || exit 1
$B/jump-136-toggle.sh

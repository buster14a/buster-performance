#!/bin/bash
# Builds main's Release compiler under the lock, then copies it out of the build tree.
cd ~/buster-fast-bench/2536-step1-claude/main
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
start=$EPOCHREALTIME
~/buster-fast-bench/exclusive.sh ./build.sh --config Release > ../build-main.log 2>&1
echo "status $? seconds $(echo "$EPOCHREALTIME - $start" | awk '{print $1 - $3}')" >> ../build-main.log
cp build/compiler ../compiler-main

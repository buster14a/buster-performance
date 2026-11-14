#!/bin/bash
# build-tree.sh NAME COMMIT: a worktree at COMMIT, its Release compiler built under the lock, copied to compiler-NAME.
set -u
name=$1
commit=$2
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
git -C repo fetch -q origin claude/magical-dijkstra-6klwmr main
[ -d "$name" ] || git -C repo worktree add --detach "../$name" "$commit"
git -C "$name" checkout -q --detach "$commit"
echo "$commit" > "$name/COMMIT"
cd "$name"
start=$EPOCHREALTIME
timeout 1800 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > "../build-$name.log" 2>&1
status=$?
echo "status $status seconds $(awk -v a="$EPOCHREALTIME" -v b="$start" 'BEGIN { print a - b }')" >> "../build-$name.log"
[ $status -eq 0 ] && cp build/compiler "../compiler-$name"

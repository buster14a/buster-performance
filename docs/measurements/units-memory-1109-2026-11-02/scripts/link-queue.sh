#!/bin/bash
# link-queue.sh OUT: the head a5f0fbc2 built, then build.sh's 41 sources linked into one executable (default budget,
# 12 GiB), and with -c under 12 GiB, two rounds; each run its own hold of the lock.
out=$1
dir=~/buster-fast-bench/1109-claude
tree=$dir/a5f0fbc2
lock() { EXCLUSIVE_OWNER=claude-1109 EXCLUSIVE_TITLE="Problem 1109: $1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1165 ~/buster-fast-bench/exclusive.sh "${@:2}" >> "$dir/link-queue.log" 2>&1; }
(cd "$tree" && lock "build a5f0fbc2" bash -c './build.sh > build.log 2>&1') || { echo "build failed" >> "$out"; exit 1; }
for round in 1 2; do
    lock "link default round $round" "$dir/units-link.sh" "$tree" "$out" link-default
    lock "link 12g round $round" "$dir/units-link.sh" "$tree" "$out" link-12g --units-memory=12884901888
    lock "-c 12g round $round" "$dir/units-run.sh" "$tree" "$out" c-12g --units-memory=12884901888
done
echo "queue done" >> "$out"

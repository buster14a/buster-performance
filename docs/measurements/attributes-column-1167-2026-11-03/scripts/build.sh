#!/bin/bash
# build.sh TREE: build TREE under the lock, one hold.
set -u
cd ~/buster-fast-bench/claude-628/$1 || exit 1
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "build $1 status $?"

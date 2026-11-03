#!/bin/bash
# usage: build-remote.sh TREE  (on benchpress)
tree="$1"
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 (-P compaction)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
  ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
echo "build exit $?" >> build.log

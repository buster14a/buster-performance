#!/bin/bash
# usage: build-close.sh TREE  (on benchpress): one locked build of TREE for #649's close-out measurement.
tree="$1"
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 close-out (build $tree)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
  ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
echo "build exit $?" >> build.log

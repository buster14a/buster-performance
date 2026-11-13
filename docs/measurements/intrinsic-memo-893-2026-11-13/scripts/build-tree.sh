#!/bin/bash
# build-tree.sh TREE: one locked Release build of TREE (BUSTER_DEBUG_INFO=0), logged in TREE/build.log.
set -u
tree=$1
cd ~/buster-fast-bench/893-claude/"$tree" || exit 1
EXCLUSIVE_OWNER=claude-893 EXCLUSIVE_TITLE="#893: the intrinsic set-up's memo (build $tree)" \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/893 \
  ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
echo "exit $?" >> build.log

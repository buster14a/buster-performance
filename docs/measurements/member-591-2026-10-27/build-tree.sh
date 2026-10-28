#!/bin/bash
# build-tree.sh TREE: builds TREE (a directory under member-591-claude) under the lock, as CI does.
cd ~/buster-fast-bench/member-591-claude/"$1" || exit 1
~/buster-fast-bench/member-591-claude/lock.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
echo "build exit $?" >> build.log

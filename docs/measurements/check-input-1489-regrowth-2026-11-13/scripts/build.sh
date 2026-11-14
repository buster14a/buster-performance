#!/bin/bash
# build.sh TREE: a znver5 Release build of TREE without debug information (DEBUG=1 for -g), one lock hold.
W=~/buster-fast-bench/1489-claude
cd $W/$1 || exit 2
EXCLUSIVE_OWNER=claude-1489 EXCLUSIVE_TITLE="Solve 1489 (check-input growth)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 \
  ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=${DEBUG:-0} ./build.sh > $W/build-$1.log 2>&1
echo "status=$?" >> $W/build-$1.log

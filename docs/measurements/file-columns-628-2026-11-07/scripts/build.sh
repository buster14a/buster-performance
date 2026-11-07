#!/bin/bash
# build.sh TREE: builds TREE (BUSTER_HOST_ARCH=znver5, as the 9700X step's) under the lock, one hold.
set -u
cd ~/buster-fast-bench/628-claude-tesla/$1 || exit 1
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: the graph's leaves" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "build $1 status $?"

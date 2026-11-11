#!/bin/sh
cd ~/buster-fast-bench/1840-claude-b3
export EXCLUSIVE_OWNER=claude-b3-1840 EXCLUSIVE_TITLE="B3 #1840 shifts Zen5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../1840-claude-b3-scripts/build.log 2>&1
echo build=$? >> ../1840-claude-b3-scripts/build.log

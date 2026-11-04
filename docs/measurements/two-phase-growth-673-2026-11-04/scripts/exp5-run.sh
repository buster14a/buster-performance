#!/bin/bash
# #673: build 7b930910 (the slow-lowering test hook) and pair it with 09e22269 under an empty jobserver (exp5.sh).
B=~/buster-fast-bench/673-claude
cd $B/head-7b930910 && EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="673: build head-7b930910" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673 BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "$(date +%T) build head-7b930910 status $? $(tail -1 build.log)" >> $B/exp5.progress
$B/exp5.sh 30
echo "$(date +%T) done" >> $B/exp5.progress

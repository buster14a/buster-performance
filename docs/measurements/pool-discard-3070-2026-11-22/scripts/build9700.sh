#!/usr/bin/env bash
# usage: build9700.sh TREE  (under ~/buster-fast-bench/3070-claude)
set -u
D=$HOME/buster-fast-bench/3070-claude
T=$1
cd $D/$T
export EXCLUSIVE_OWNER=claude-3070 EXCLUSIVE_TITLE="#3070 step 1: warm lanes, root image" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
timeout 1800 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build-$T.log 2>&1
echo "build exit $?" >> $D/build-$T.log

#!/bin/bash
D=~/buster-fast-bench/1447-claude-c9
cd $D
export EXCLUSIVE_OWNER=claude-1447-c9
export EXCLUSIVE_TITLE="C9: attributes still refused by name (#1447)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxng4aKeNZmJe3C1fFZf
(cd head && git fetch -q origin $1 && git checkout -q --detach FETCH_HEAD)
~/buster-fast-bench/exclusive.sh bash -c "cd $D/head && BUSTER_DEBUG_INFO=0 ./build.sh" > build-head-$2.log 2>&1
./measure.sh $2

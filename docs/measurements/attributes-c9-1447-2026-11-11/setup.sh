#!/bin/bash
D=~/buster-fast-bench/1447-claude-c9
mkdir -p $D && cd $D
export EXCLUSIVE_OWNER=claude-1447-c9
export EXCLUSIVE_TITLE="C9: attributes still refused by name (#1447)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxng4aKeNZmJe3C1fFZf
cp ~/buster-fast-bench/1447-claude-address-space/sqlite3.c . 
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
(cd base && git fetch -q origin main && git checkout -q --detach $1)
(cd head && git fetch -q origin $2 && git checkout -q --detach FETCH_HEAD)
for t in base head; do
  ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > build-$t.log 2>&1
done
echo SETUP-DONE >> build-head.log

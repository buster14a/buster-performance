#!/bin/bash
cd ~/buster-fast-bench/1840-claude-d1
export EXCLUSIVE_OWNER=claude-1840-d1 EXCLUSIVE_TITLE="#1840 D1: one-lane moves, Zen 5 rows" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndSFy6uFvzyrjksKEf
cd head && git fetch -q origin ir/1840-lane-moves && git checkout -q -f FETCH_HEAD && git log --oneline -1
echo "== build $(date -Is)"
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-head.log 2>&1; echo "build rc=$?"
echo "== measure $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > ../zen5-lanes-table.txt 2> ../zen5-lanes.err; echo "measure rc=$?"
echo "== done $(date -Is)"

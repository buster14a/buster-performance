#!/bin/bash
cd ~/buster-fast-bench/1840-claude-e1b
export EXCLUSIVE_OWNER=claude-1840-e1b EXCLUSIVE_TITLE="#1840 E1b: lane_unary, Zen 5 rows" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneX6TiJKhYDcizrAZh
cd unary && git fetch -q https://github.com/buster14a/buster ir/1840-lane-unary && git checkout -q -f FETCH_HEAD && git log --oneline -1
echo "== build $(date -Is)"
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-unary.log 2>&1; echo "build rc=$?"
echo "== measure $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > ../zen5-unary-table.txt 2> ../zen5-unary.err; echo "measure rc=$?"
echo "== done $(date -Is)"

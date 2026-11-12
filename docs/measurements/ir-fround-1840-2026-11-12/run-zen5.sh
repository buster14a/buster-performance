#!/bin/bash
cd ~/buster-fast-bench/1840-claude-e1b
export EXCLUSIVE_OWNER=claude-1840-e1b EXCLUSIVE_TITLE="#1840 E1b: fround, Zen 5 rows" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneX6TiJKhYDcizrAZh
cd fround && git fetch -q https://github.com/buster14a/buster ir/1840-fround && git checkout -q -f FETCH_HEAD && git log --oneline -1
echo "== build $(date -Is)"
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-fround.log 2>&1; echo "build rc=$?"
echo "== measure $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > ../zen5-fround-table.txt 2> ../zen5-fround.err; echo "measure rc=$?"
echo "== done $(date -Is)"

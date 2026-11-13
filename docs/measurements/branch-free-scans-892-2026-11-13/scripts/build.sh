#!/bin/bash
# build.sh TREE: a locked Release build of ~/buster-fast-bench/892-claude/TREE (debug info kept for line tables).
set -u
tree=${1:?tree}
cd ~/buster-fast-bench/892-claude/$tree || exit 2
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
start=$(date +%s)
~/buster-fast-bench/exclusive.sh timeout 1500 ./build.sh > ../build-$tree.log 2>&1
status=$?
echo "build $tree status $status seconds $(( $(date +%s) - start ))" >> ../build-$tree.log
echo done >> ../build-$tree.log

#!/bin/sh
# #1444 items 1 and 2: builds TREE (a worktree at REVISION with PATCH applied) at four placements of
# main_unit_checker.c's code, as build.sh does, under the 9700X's lock, one hold.
#   build-patch.sh NAME REVISION PATCH
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
name=$1
revision=$2
patch=$3
shifts="0 1088 2112 3136"
[ -d tree-$name ] || (cd repo && git worktree add -q --detach $d/tree-$name $revision)
(cd tree-$name && git checkout -q --detach $revision && git checkout -q -- . && git apply $d/$patch && git rev-parse HEAD && git diff --stat && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-$name main_unit_checker.c $shifts) > build-$name.log 2>&1
sha256sum shifts-$name/compiler-* >> build-$name.log
echo done >> build-$name.log

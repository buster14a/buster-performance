#!/bin/sh
# #1444 items 1 and 2: builds TREE (a worktree of the repository at REVISION) at four placements of
# main_unit_checker.c's code (./build.sh shifts), as the benchmark builds are (znver5, no debug information), under the
# 9700X's lock, one hold.
#   build.sh NAME REVISION
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
name=$1
revision=$2
shifts="0 1088 2112 3136"
(cd repo && git fetch -q origin "$revision" 2>/dev/null || true)
[ -d tree-$name ] || (cd repo && git worktree add -q --detach $d/tree-$name $revision)
(cd tree-$name && git checkout -q --detach $revision && git rev-parse HEAD && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-$name main_unit_checker.c $shifts) > build-$name.log 2>&1
sha256sum shifts-$name/compiler-* >> build-$name.log
echo done >> build-$name.log

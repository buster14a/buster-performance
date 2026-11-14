#!/bin/sh
# #1444, the checker's section: builds tree-NAME (a worktree at REVISION, with the start list of LIST_REVISION if given)
# at four placements of main_unit_checker.c's code (./build.sh shifts), as the benchmark builds are (znver5, no debug
# information), under the 9700X's lock, one hold.
#   build-tree.sh NAME REVISION [LIST_REVISION]
set -eu
d=~/buster-fast-bench/1444-claude-checker
cd $d
. $d/env.sh
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
name=$1
revision=$2
list=${3:-}
shifts="0 1088 2112 3136"
[ -d tree-$name ] || (cd repo && git worktree add -q --detach $d/tree-$name $revision)
(cd tree-$name && git checkout -q --detach $revision && git checkout -q -- . && git clean -fdq && { [ -z "$list" ] || git checkout -q $list -- cmake/BusterStartOrder.txt; } && git rev-parse HEAD && git status --short && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-$name main_unit_checker.c $shifts) > build-$name.log 2>&1
sha256sum shifts-$name/compiler-* >> build-$name.log
for s in $shifts; do test -x shifts-$name/compiler-$s; done
echo done >> build-$name.log

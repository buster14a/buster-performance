#!/bin/bash
# #2243 over the checker code's placements (#1233): base and head built with BUSTER_CHECKER_OFFSET 1024 and 2048 (and
# the default 0 builds), each build under its own lock hold; then one time-runs over the three placements of each.
D=~/buster-fast-bench/1447-claude-d3
cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: #2243 over placements"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndQMcsMYmMXdjncrCg
for side in base head; do
  for off in 1024 2048; do
    t=2243-$side-o$off
    [ -d $t ] || git -C repo worktree add -q --detach $D/$t $(git -C $D/2243-$side rev-parse HEAD)
    if [ ! -x $t/build/compiler ]; then
      (cd $t && ~/buster-fast-bench/exclusive.sh env BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$off ./build.sh > ../build-$t.log 2>&1) || { echo "build $t failed"; exit 1; }
    fi
    echo "$t $(git -C $t rev-parse HEAD)"
  done
done
sha256sum 2243-*/build/compiler > layout-compilers.sha256
S=$D/2280-head/src
~/buster-fast-bench/exclusive.sh taskset -c 2 $D/2243-head/build/compiler time-runs --runs 15 --warmups 2 \
  --build base $D/2243-base/build/compiler --build head $D/2243-head/build/compiler \
  --build base $D/2243-base-o1024/build/compiler --build head $D/2243-head-o1024/build/compiler \
  --build base $D/2243-base-o2048/build/compiler --build head $D/2243-head-o2048/build/compiler \
  --list -fsyntax-only -march=native -I$S -fwrapv -funsigned-char -fno-strict-aliasing -Wall $S/buster/compiler/main.c \
  --list -fsyntax-only /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c > layout-2243.txt 2>&1
echo "layout exit $?"
echo LAYOUT-DONE

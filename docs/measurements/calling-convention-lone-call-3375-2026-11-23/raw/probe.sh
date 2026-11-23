#!/bin/bash
# Builds PATCH in the mutation tree (Develop) and runs test-calling-convention, under the lock.
D=~/buster-fast-bench/3375-claude
cd $D
T=mut-tree
PATCH=$1
OUT=$2
until [ -f mut3/done ]; do sleep 10; done
git -C $T checkout -q -f c7809112
git -C $T apply $D/$PATCH
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-fixture-check EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
env $L ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$T && ./build.sh > $D/$OUT.build.log 2>&1 && ./build/compiler test-calling-convention > $D/$OUT.log 2>&1; echo \"exit \$?\" >> $D/$OUT.log"

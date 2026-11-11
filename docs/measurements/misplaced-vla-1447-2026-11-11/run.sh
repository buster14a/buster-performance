#!/bin/bash
# #1447 C3: typedef/parameter declarator recovery, base main vs head branch, error-free -fsyntax-only.
set -u
D=~/buster-fast-bench/1447-c3-claude
cd $D
export EXCLUSIVE_OWNER=claude-1447-c3 EXCLUSIVE_TITLE="#1447 C3: invalid declarations and reader errors" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngPtvUfDy4W16JqCMg
X=~/buster-fast-bench/exclusive.sh
BASE_COMMIT=$1
HEAD_BRANCH=$2
if [ ! -d base ]; then git clone -q https://github.com/buster14a/buster base; fi
git -C base fetch -q origin main && git -C base checkout -q $BASE_COMMIT
if [ ! -d head ]; then git clone -q base head; fi
git -C head fetch -q https://github.com/buster14a/buster $HEAD_BRANCH && git -C head checkout -q FETCH_HEAD
echo "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD)"
for t in base head; do (cd $t && BUSTER_HOST_ARCH=znver5 $X ./build.sh > ../build-$t.log 2>&1; echo "$t build $?"); done
SQL=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
F="-march=native -Isrc -fwrapv -funsigned-char"
cd base
$X taskset -c 2 ./build/compiler time-runs --runs 15 --warmups 2 --build base ../base/build/compiler --build head ../head/build/compiler \
  --list -fsyntax-only -w $SQL --list -fsyntax-only $SQL --list -fsyntax-only $F src/buster/compiler/main.c > ../times-syntax.txt 2>&1
echo "syntax $?"
echo RUN-DONE

#!/bin/bash
set -e
D=~/buster-fast-bench/1447-claude-invalid
cd $D
export EXCLUSIVE_OWNER=claude-1447-invalid
export EXCLUSIVE_TITLE="#1447: invalid declarations stay bound"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvh5du4nLNHAcvXWSf
for t in base head; do
  if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
done
git -C base fetch -q origin main
git -C base checkout -q 2c62bb2
git -C head fetch -q origin claude/1447-invalid-declarations
git -C head checkout -q FETCH_HEAD
git -C base log --oneline -1; git -C head log --oneline -1
cp ~/buster-fast-bench/refine-claude/inputs/sqlite3.c $D/sqlite3.c
for t in base head; do
  (cd $t && ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-$t.log 2>&1)
  tail -1 build-$t.log
done
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times.txt 2>&1
echo TIMES-DONE >> times.txt

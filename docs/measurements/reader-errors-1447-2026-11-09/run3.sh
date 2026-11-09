#!/bin/bash
set -e
D=~/buster-fast-bench/1447-claude-invalid
cd $D
export EXCLUSIVE_OWNER=claude-1447-enum-redefinition
export EXCLUSIVE_TITLE="#1447: C23 enum redefinitions"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1928
until grep -q TIMES-DONE times-atomic.txt 2>/dev/null; do sleep 20; done
if [ ! -d enum ]; then git clone -q https://github.com/buster14a/buster enum; fi
git -C enum fetch -q origin claude/1447-enum-redefinition
git -C enum checkout -q FETCH_HEAD
git -C enum log --oneline -1
(cd enum && ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-enum.log 2>&1)
tail -1 build-enum.log
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 --build head $D/head/build/compiler --build enum $D/enum/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times-enum.txt 2>&1
echo TIMES-DONE >> times-enum.txt

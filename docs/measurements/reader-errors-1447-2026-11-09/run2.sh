#!/bin/bash
set -e
D=~/buster-fast-bench/1447-claude-invalid
cd $D
export EXCLUSIVE_OWNER=claude-1447-atomic-tag
export EXCLUSIVE_TITLE="#1447: tags in _Atomic/typeof specifiers"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvh5du4nLNHAcvXWSf
until grep -q TIMES-DONE times.txt 2>/dev/null; do sleep 20; done
if [ ! -d atomic ]; then git clone -q https://github.com/buster14a/buster atomic; fi
git -C atomic fetch -q origin claude/1447-atomic-tag
git -C atomic checkout -q FETCH_HEAD
git -C atomic log --oneline -1
(cd atomic && ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-atomic.log 2>&1)
tail -1 build-atomic.log
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 --build base $D/base/build/compiler --build atomic $D/atomic/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times-atomic.txt 2>&1
echo TIMES-DONE >> times-atomic.txt

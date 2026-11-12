#!/bin/bash
cd ~/buster-fast-bench/1840-claude-e1b
export EXCLUSIVE_OWNER=claude-1840-e1b EXCLUSIVE_TITLE="#1840 E1b: reductions, compile timing" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneX6TiJKhYDcizrAZh
for t in base head; do
  echo "== build $t $(date -Is)"
  (cd $t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$t.log 2>&1; echo "build $t rc=$?")
done
H=$PWD/head
for mode in tier1 tier0; do
  extra=""; [ $mode = tier1 ] && extra="--tier1"
  echo "== time $mode $(date -Is)"
  ~/buster-fast-bench/exclusive.sh taskset -c 2 $H/build/compiler time-runs --runs 11 --warmups 2 --build base $PWD/base/build/compiler --build head $H/build/compiler \
    --list -c $extra -march=znver5 -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null $H/src/buster/compiler/main.c > time-$mode.txt 2> time-$mode.err
  echo "time $mode rc=$?"
done
echo "== done $(date -Is)"

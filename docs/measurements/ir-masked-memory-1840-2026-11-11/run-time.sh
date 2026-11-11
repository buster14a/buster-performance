#!/bin/bash
cd ~/buster-fast-bench/1840-claude-d1
export EXCLUSIVE_OWNER=claude-1840-d1 EXCLUSIVE_TITLE="#1840 D1: masked loads and stores, --tier1 timing" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndSFy6uFvzyrjksKEf
(cd head && git fetch -q origin ir/1840-masked-memory && git checkout -q -f FETCH_HEAD && git log --oneline -1)
for t in base head; do
  echo "== build $t $(date -Is)"
  (cd $t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$t.log 2>&1; echo "build $t rc=$?")
done
H=$PWD/head
echo "== time $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 $H/build/compiler time-runs --runs 11 --warmups 2 --build base $PWD/base/build/compiler --build head $H/build/compiler \
  --list -c --tier1 -march=znver5 -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null $H/src/buster/compiler/main.c > time-tier1.txt 2> time-tier1.err
echo "time rc=$?"
echo "== done $(date -Is)"

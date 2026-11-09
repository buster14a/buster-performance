#!/bin/bash
# #1832 on the 9700X: build base and head, benchmark-calling-convention base vs head, then the GCC cross-check.
set -u
cd ~/buster-fast-bench/1832-claude
export EXCLUSIVE_OWNER=claude-1832 EXCLUSIVE_TITLE="#1832: psABI classifier's remaining gaps" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1863
X=~/buster-fast-bench/exclusive.sh
BASE=cb608c1f616f8fe26234bcaaa869caccc571de63
HEAD=${HEAD_REV:?}
for name in base head; do
  rev=$BASE; [ $name = head ] && rev=$HEAD
  if [ ! -d $name ]; then git clone -q https://github.com/buster14a/buster $name; fi
  (cd $name && git fetch -q origin claude/psabi-gaps-137 main && git checkout -q $rev)
  (cd $name && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 $X ./build.sh > ../build-$name.log 2>&1) || { echo "build $name failed"; exit 1; }
done
echo "built $(cd base && git rev-parse --short HEAD) $(cd head && git rev-parse --short HEAD)"
: > bench.log
for i in 1 2 3; do
  for name in base head; do
    echo "== $name run $i" >> bench.log
    (cd $name && $X taskset -c 2 ./build/compiler benchmark-calling-convention >> ../bench.log 2>&1)
  done
done
echo benched
: > gcc-cross.log
for s in $(seq 1 100); do
  out=$(cd head && $X ./build/compiler test-calling-convention --cross-check --seed $s 2>&1)
  if echo "$out" | grep -Eq "failures [1-9]|[1-9][0-9]* failed"; then echo "SEED $s FAIL" >> gcc-cross.log; echo "$out" | grep -Ev "failures 0|, 0 failed" | head -60 >> gcc-cross.log; else echo "SEED $s ok $(echo "$out" | grep -c 'gcc,')" >> gcc-cross.log; fi
done
echo DONE >> gcc-cross.log

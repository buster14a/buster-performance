#!/bin/bash
# buster#1840 byte shuffles by an immediate: -c and --tier1 -c main.c, main 26f0bb0e (base) against 3c9ab01b (head).
R=~/buster-fast-bench/1840-claude-g1
S=~/buster-fast-bench/1840-claude-g1-scripts
W=~/buster-fast-bench/1840-claude-g1-time
export EXCLUSIVE_OWNER=claude-1840-g1 EXCLUSIVE_TITLE="#1840 byte shuffles by an immediate: compile timing" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
cd $R && git fetch -q origin claude/trusting-thompson-ye0dvx main
mkdir -p $W
[ -d $W/base ] || git -C $R worktree add -q --detach $W/base 26f0bb0e
[ -d $W/head ] || git -C $R worktree add -q --detach $W/head 3c9ab01b
for t in base head; do echo "$t $(git -C $W/$t rev-parse HEAD)"; done > $S/time-commits.txt
for t in base head; do
  echo "== build $t $(date -Is)"
  (cd $W/$t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/time-holds.txt; exec ./build.sh" > $S/time-build-$t.log 2>&1; echo "build $t rc=$?")
done
sha256sum $W/base/build/compiler $W/head/build/compiler > $S/time-binaries.txt
H=$W/head
for mode in tier1 tier0; do
  extra=""; [ $mode = tier1 ] && extra="--tier1"
  echo "== time $mode $(date -Is)"
  ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/time-holds.txt; exec taskset -c 2 $H/build/compiler time-runs --runs 11 --warmups 2 --build base $W/base/build/compiler --build head $H/build/compiler --list -c $extra -march=znver5 -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null $H/src/buster/compiler/main.c" > $S/time-$mode.txt 2> $S/time-$mode.err
  echo "time $mode rc=$?"
done
echo "== done $(date -Is)"

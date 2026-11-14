#!/bin/bash
# #2716: main against the lanes commit, -c main.c at native and at x86-64 (where the lanes path is live), time-runs
# under the lock, and the target_clones probes' compile at x86-64.
W=$HOME/buster-fast-bench/2716-lanes
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2716-lanes EXCLUSIVE_TITLE="Issue 2716: target_clones copies lane by lane" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2716
R=$HOME/buster-fast-bench/1840-fma/repo
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
git -C $R fetch -q origin main
git -C $R fetch -q -f $W/lanes.bundle claude/focused-ride-jlo904:lanes-head
for t in main:56b5864 head:lanes-head; do
  n=${t%%:*}; c=${t#*:}
  [ -d $W/$n ] || git -C $R worktree add -q --detach $W/$n $c
  (cd $W/$n && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$n.log 2>&1)
  cp $W/$n/build/compiler $W/compiler-$n
  echo "built $n $(git -C $W/$n rev-parse --short HEAD): $(tail -1 $W/build-$n.log)" >> progress.txt
done
H=$W/head
B="--build main $W/compiler-main --build head $W/compiler-head --build main-again $W/compiler-main"
TR="time-runs --runs 3 --copies 3"
for m in native x86-64; do
  clang -dM -E -march=$m -fwrapv -funsigned-char -x c /dev/null > $W/predefines-$m.h
  ARGS="-march=$m -I$H/src -fwrapv -funsigned-char --predefines $W/predefines-$m.h"
  (cd $H && $L ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-$m.o > $W/tr-$m.txt 2>&1)
  echo "time-runs -c $m status $? $(date -u +%FT%TZ)" >> progress.txt
done
echo lanesdone >> progress.txt

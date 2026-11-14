#!/bin/bash
# buster#1840 families 1 to 4: -c and --tier1 -c main.c, main 26f0bb0e (base, the first record's build) against 2f0aa376.
R=~/buster-fast-bench/1840-claude-g1
S=~/buster-fast-bench/1840-claude-g2-scripts
W=~/buster-fast-bench/1840-claude-g1-time
export EXCLUSIVE_OWNER=claude-1840-g2 EXCLUSIVE_TITLE="#1840 item 4 families: compile timing" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
cd $R && git fetch -q $S/g3.bundle g2-measure
[ -d $W/head2 ] || git -C $R worktree add -q --detach $W/head2 2f0aa376
for t in base head2; do echo "$t $(git -C $W/$t rev-parse HEAD)"; done > $S/time-commits.txt
echo "== build head2 $(date -Is)"
(cd $W/head2 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/time-holds.txt; exec ./build.sh" > $S/time-build-head2.log 2>&1; echo "build head2 rc=$?")
sha256sum $W/base/build/compiler $W/head2/build/compiler > $S/time-binaries.txt
H=$W/head2
for mode in tier1 tier0; do
  extra=""; [ $mode = tier1 ] && extra="--tier1"
  echo "== time $mode $(date -Is)"
  ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/time-holds.txt; exec taskset -c 2 $H/build/compiler time-runs --runs 11 --warmups 2 --build base $W/base/build/compiler --build head $H/build/compiler --list -c $extra -march=znver5 -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null $H/src/buster/compiler/main.c" > $S/time-$mode.txt 2> $S/time-$mode.err
  echo "time $mode rc=$?"
done
echo "== done $(date -Is)"

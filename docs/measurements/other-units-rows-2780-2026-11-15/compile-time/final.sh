#!/bin/bash
# The PR's compile-time A/B on the 9700X: the merged head of claude/focused-ride-jlo904 (#2780, #2410, #2216) against
# main 750f6a04. Release builds; time-runs under ab (base, head, base again; one lock hold a run) of -c and --tier1 -c
# main.c.
W=$HOME/buster-fast-bench/2780-final
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2780 EXCLUSIVE_TITLE="Issues 2780, 2410, 2216: the PR's compile-time A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2780
mkdir -p $W && cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
R=$HOME/buster-fast-bench/2780-claude/repo
git -C $R fetch -q origin main claude/focused-ride-jlo904
for t in base:750f6a04 head:c1e072b4; do
  n=${t%%:*}; c=${t#*:}
  [ -d $n ] || git -C $R worktree add -q --detach $W/$n $c
  (cd $W/$n && git checkout -q --detach $c && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$n.log 2>&1)
  echo "built $n $(git -C $W/$n rev-parse --short HEAD): $(tail -1 $W/build-$n.log)" >> progress.txt
done
for n in base head; do cp $W/$n/build/compiler $W/compiler-$n; clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/$n/build/predefines.h; done
H=$W/head
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
B="--build base $W/compiler-base --build head $W/compiler-head --build base-again $W/compiler-base"
TR="time-runs --runs 3 --copies 3"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1)
echo "time-runs -c status $? $(date -u +%FT%TZ)" >> progress.txt
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1)
echo "time-runs --tier1 status $? $(date -u +%FT%TZ)" >> progress.txt
echo "donefinal" >> progress.txt

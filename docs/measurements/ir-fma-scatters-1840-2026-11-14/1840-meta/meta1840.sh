#!/bin/bash
# The verifier's metadata table (#1840's +0.30% --tier1 instructions): main, the FMA commit and the table's commit,
# instructions and cycles of -c and --tier1 -c main.c, and main against the head by time-runs.
W=$HOME/buster-fast-bench/1840-meta
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-meta EXCLUSIVE_TITLE="Issue 1840: IR verifier metadata table" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
R=$HOME/buster-fast-bench/1840-fma/repo
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
git -C $R fetch -q origin main
git -C $R fetch -q $W/meta.bundle local/1840-rest:meta-head
for t in main:2909b2c fma:meta-head~1 meta:meta-head; do
  n=${t%%:*}; c=${t#*:}
  [ -d $W/$n ] || git -C $R worktree add -q --detach $W/$n $c
  (cd $W/$n && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$n.log 2>&1)
  cp $W/$n/build/compiler $W/compiler-$n
  echo "built $n $(git -C $W/$n rev-parse --short HEAD): $(tail -1 $W/build-$n.log)" >> progress.txt
done
H=$W/meta
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $H/build/predefines.h
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
for mode in c tier1; do
  flag=""; [ $mode = tier1 ] && flag="--tier1"
  for n in main fma meta; do
    $L taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $W/compiler-$n $flag -c $ARGS $H/src/buster/compiler/main.c -o $W/out-$n-$mode.o > /dev/null 2> $W/stat-$n-$mode.txt
    echo "stat $mode $n $(grep instructions $W/stat-$n-$mode.txt | cut -d, -f1) $(grep cycles $W/stat-$n-$mode.txt | cut -d, -f1)" >> progress.txt
  done
done
B="--build main $W/compiler-main --build head $W/compiler-meta --build main-again $W/compiler-main"
TR="time-runs --runs 3 --copies 3"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-meta -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1)
echo "time-runs --tier1 status $? $(date -u +%FT%TZ)" >> progress.txt
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-meta -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1)
echo "time-runs -c status $? $(date -u +%FT%TZ)" >> progress.txt
echo metadone >> progress.txt

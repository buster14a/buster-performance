#!/bin/bash
# #1840: the scatter commit's --tier1 instructions with the extra count by an opcode table (candidate), against the FMA
# and table build and the scatter build: perf stat instructions and cycles, each run under its own hold.
W=$HOME/buster-fast-bench/1840-cand
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-cand EXCLUSIVE_TITLE="Issue 1840: scatter extra-count candidate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2772
R=$HOME/buster-fast-bench/1840-fma/repo
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
git -C $R fetch -q origin main
git -C $R fetch -q -f $W/cand.bundle HEAD:cand-head
[ -d $W/cand ] || git -C $R worktree add -q --detach $W/cand cand-head
(cd $W/cand && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-cand.log 2>&1)
cp $W/cand/build/compiler $W/compiler-cand
cp $HOME/buster-fast-bench/1840-meta/compiler-meta $W/compiler-meta
cp $HOME/buster-fast-bench/1840-scatter/compiler-head $W/compiler-scatter
echo "built cand $(git -C $W/cand rev-parse --short HEAD): $(tail -1 $W/build-cand.log)" >> progress.txt
H=$W/cand
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/predefines.h
ARGS="--tier1 -c -march=native -I$H/src -fwrapv -funsigned-char --predefines $W/predefines.h $H/src/buster/compiler/main.c"
for n in meta scatter cand; do
  $L taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $W/compiler-$n $ARGS -o $W/out-$n.o > /dev/null 2> $W/stat-$n.txt
  echo "stat $n $(grep instructions $W/stat-$n.txt | cut -d, -f1) $(grep cycles $W/stat-$n.txt | cut -d, -f1)" >> progress.txt
done
echo canddone >> progress.txt

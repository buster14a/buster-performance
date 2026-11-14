#!/bin/bash
# #1840: attribute the scatter commit's --tier1 -c main.c instructions (FMA and the verifier's table, against those and
# the scatter) by IBS op samples per symbol. The two Release builds without -g that the earlier jobs made.
W=$HOME/buster-fast-bench/1840-ibs2
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-ibs2 EXCLUSIVE_TITLE="Issue 1840: scatter instruction delta" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
mkdir -p $W && cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
cp $HOME/buster-fast-bench/1840-meta/compiler-meta $W/compiler-base
cp $HOME/buster-fast-bench/1840-scatter/compiler-head $W/compiler-head
H=$HOME/buster-fast-bench/1840-scatter/head
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/predefines.h
ARGS="--tier1 -c -march=native -I$H/src -fwrapv -funsigned-char --predefines $W/predefines.h $H/src/buster/compiler/main.c"
for i in 0 1 2 3; do
  for n in base head; do
    $L taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c $((400003 + 2 * i)) -o $W/ibs-$n-$i.data -- ./compiler-$n $ARGS -o $W/out-$n.o > $W/ibs-$n-$i.log 2>&1
  done
  echo "recorded $i $(date -u +%FT%TZ)" >> progress.txt
done
for n in base head; do
  for i in 0 1 2 3; do
    $L perf report -i $W/ibs-$n-$i.data --stdio --sort sym -F sample,sym -q > $W/syms-$n-$i.txt 2> $W/report-$n-$i.log
  done
done
echo ibs2done >> progress.txt

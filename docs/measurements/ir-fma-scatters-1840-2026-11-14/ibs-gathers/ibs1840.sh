#!/bin/bash
# #1840: attribute `--tier1 -c main.c`'s +56.5 M instructions (c70562f against main 8023523) by IBS op samples per
# source line. Release builds with -g; every build, count, record and report under its own lock hold.
W=$HOME/buster-fast-bench/1840-ibs
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-ibs EXCLUSIVE_TITLE="Issue 1840: Tier 1 instruction delta" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
mkdir -p $W && cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main
for t in base:8023523 head:c70562f; do
  n=${t%%:*}; c=${t#*:}
  [ -d $n ] || git -C repo worktree add -q --detach ../$n $c
  (cd $W/$n && $L ./build.sh --config Release > $W/build-$n.log 2>&1)
  cp $W/$n/build/compiler $W/compiler-$n
  echo "built $n $c: $(tail -1 $W/build-$n.log)" >> progress.txt
done
H=$W/head
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/predefines.h
ARGS="--tier1 -c -march=native -I$H/src -fwrapv -funsigned-char --predefines $W/predefines.h $H/src/buster/compiler/main.c"
for n in base head; do
  $L taskset -c 2 perf stat -x, -e instructions:u -o $W/stat-$n.txt ./compiler-$n $ARGS -o $W/out-$n.o > /dev/null 2>&1
  echo "stat $n $(grep instructions $W/stat-$n.txt | cut -d, -f1)" >> progress.txt
done
for i in 0 1 2 3; do
  for n in base head; do
    $L taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c $((400003 + 2 * i)) -o $W/ibs-$n-$i.data -- ./compiler-$n $ARGS -o $W/out-$n.o > $W/ibs-$n-$i.log 2>&1
  done
  echo "recorded $i $(date -u +%FT%TZ)" >> progress.txt
done
for n in base head; do
  for i in 0 1 2 3; do
    $L perf report -i $W/ibs-$n-$i.data --stdio --sort srcline -F sample,srcline -q > $W/lines-$n-$i.txt 2> $W/report-$n-$i.log
    $L perf report -i $W/ibs-$n-$i.data --stdio --sort sym -F sample,sym -q > $W/syms-$n-$i.txt 2>> $W/report-$n-$i.log
  done
  echo "reported $n $(date -u +%FT%TZ)" >> progress.txt
done
echo ibsdone >> progress.txt

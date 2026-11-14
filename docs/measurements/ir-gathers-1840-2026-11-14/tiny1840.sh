#!/bin/bash
# #1840: is `--tier1`'s +56.5 M instructions on main.c a per-process cost? Instructions of a one-function file by each
# build, Tier 0 and Tier 1, each count under its own lock hold.
W=$HOME/buster-fast-bench/1840-claude-h1
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-h1 EXCLUSIVE_TITLE="Issues 1834 1840" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2722
cd $W
printf "int f(int x) { return x + 1; }\n" > tiny.c
for t in base final; do
  for o in tier1 tier0; do
    flag=""; [ $o = tier1 ] && flag=--tier1
    $L taskset -c 2 perf stat -x, -e instructions:u -o stat-tiny-$t-$o.txt ./compiler-$t $flag -c -march=native tiny.c -o tiny-$t-$o.o > /dev/null 2>&1
    echo "tiny $t $o $(grep instructions stat-tiny-$t-$o.txt | cut -d, -f1)" >> $W/progress.txt
  done
done
echo tinydone >> $W/progress.txt

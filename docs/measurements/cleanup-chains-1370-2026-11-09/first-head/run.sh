#!/bin/bash
# #1370 base vs head on the 9700X. Each step takes the lock for itself alone.
set -u
D=$HOME/buster-fast-bench/1370-claude
X="env EXCLUSIVE_OWNER=claude-1370 EXCLUSIVE_TITLE=#1370-cleanup-chains EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnstcbbn8og2JLqUua2 $HOME/buster-fast-bench/exclusive.sh"
BASE=cb608c1f61; HEAD=$1
cd $D
for t in base:$BASE head:$HEAD; do n=${t%%:*}; r=${t#*:}
  [ -d trees/$n ] || git clone -q https://github.com/buster14a/buster trees/$n
  git -C trees/$n fetch -q origin main checker/1370-cleanup-chains; git -C trees/$n checkout -q $r
  $X bash -c "cd $D/trees/$n && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh" > build-$n.log 2>&1 || { echo "build $n failed"; exit 1; }
done
B=$D/trees/base/build/compiler; H=$D/trees/head/build/compiler
cc -O2 -o shapes shapes.c
mkdir -p in out
for s in returns nested loop goto none; do for n in 10 40 85 400 2000 10000; do ./shapes $s $n > in/$s-$n.c; done; done
# Sizes: .text and call count of g, both tiers (no timing; outside the lock is fine but keep it uniform)
printf "shape\tN\tbuild\ttier\tstatus\ttext\tcalls\n" > sizes.tsv
for s in returns nested loop goto none; do for n in 10 40 85 400 2000 10000; do for b in base head; do for t in 0 1; do
  C=$B; [ $b = head ] && C=$H; f=""; [ $t = 1 ] && f=--tier1
  if $C $f -c in/$s-$n.c -o out/o.o 2>/dev/null; then
    tx=$(size -A out/o.o | awk '$1==".text"{print $2}'); c=$(objdump -d out/o.o | grep -c "call"); printf "$s\t$n\t$b\t$t\tok\t$tx\t$c\n" >> sizes.tsv
  else printf "$s\t$n\t$b\t$t\terror\t\t\n" >> sizes.tsv; fi
done; done; done; done
# Compile time: whole processes, Williams order, pinned, each list one lock.
for s in returns loop; do for n in 85 2000 10000; do
  $X taskset -c 2 $H time-runs --runs 11 --warmups 2 --build base $B --build head $H --list -c in/$s-$n.c -o /dev/null > time-$s-$n.txt 2>&1
  $X taskset -c 2 $H time-runs --runs 11 --warmups 2 --build base $B --build head $H --list --tier1 -c in/$s-$n.c -o /dev/null > time-$s-$n-tier1.txt 2>&1
done; done
for n in 2000 10000; do $X taskset -c 2 $H time-runs --runs 11 --warmups 2 --build base $B --build head $H --list -c in/none-$n.c -o /dev/null > time-none-$n.txt 2>&1; done
S=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
$X taskset -c 2 $H time-runs --runs 11 --warmups 2 --build base $B --build head $H --list -c $S -o /dev/null > time-sqlite3.txt 2>&1
$B -c $S -o out/sb.o; $H -c $S -o out/sh.o; cmp out/sb.o out/sh.o && echo "sqlite3.o identical" > identical.txt || echo "sqlite3.o differs" > identical.txt
$B --tier1 -c $S -o out/sb1.o; $H --tier1 -c $S -o out/sh1.o; cmp out/sb1.o out/sh1.o && echo "sqlite3.o tier1 identical" >> identical.txt || echo "sqlite3.o tier1 differs" >> identical.txt
for n in 2000 10000; do $B -c in/none-$n.c -o out/nb.o; $H -c in/none-$n.c -o out/nh.o; cmp -s out/nb.o out/nh.o && echo "none-$n identical" >> identical.txt || echo "none-$n differs" >> identical.txt; done
echo done > finished

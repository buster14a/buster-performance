#!/bin/bash
# #2826 kernels: --tier1 against --tier1-passes=+memory (and clang -O2) on the 9700X. Tree $1. Under exclusive.sh.
D=~/buster-fast-bench/2826-claude
B=$D/$1/build/compiler
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin | head -1)/clang
cd $D/mk
echo "tree $1 commit $(git -C $D/$1 rev-parse HEAD) policy ${BUSTER_MEMORY_POLICY:-0}"; cat /proc/loadavg
args=()
for k in m1 m2 m3 m4; do
  $CLANG -O2 -o $k.clang-O2 $k.c
  $B -c --tier1 -o $k.t1.o $k.c && $CLANG -o $k.tier1 $k.t1.o
  $B -c --tier1 --tier1-passes=+memory --tier1-report -o $k.t1m.o $k.c 2> $k.report && $CLANG -o $k.tier1-memory $k.t1m.o
  echo "$k forwarded $(tr '\t' '\n' < $k.report | grep loads_forwarded=)"
  for b in clang-O2 tier1 tier1-memory; do echo "$k $b $(./$k.$b 1000)"; done
done
for k in m1 m2 m3 m4; do
  taskset -c 2 $B time-runs --runs 11 --warmups 1 --build clang-O2 ./$k.clang-O2 --build tier1 ./$k.tier1 --build tier1-memory ./$k.tier1-memory --list 100000000 | grep -A4 "user cycles"
done
cat /proc/loadavg

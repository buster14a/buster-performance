#!/bin/sh
# usage: bench.sh OUTDIR TREE... ; builds chain.c with each tree's compiler (Tier 0 and --tier1) and clang, times each.
set -e
out=$1; shift
mkdir -p $out; cd $out
cp ../chain.c .
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin 2>/dev/null | head -1)/clang
[ -x "$CLANG" ] || CLANG=clang
$CLANG -O0 chain.c -o clang-O0; $CLANG -O2 chain.c -o clang-O2
for t in "$@"; do ../$t/build/compiler chain.c -o $t-tier0; ../$t/build/compiler --tier1 chain.c -o $t-tier1; done
for b in clang-O0 clang-O2 $(for t in "$@"; do echo $t-tier0 $t-tier1; done); do
  ./$b > $b.out
  best=999999
  for r in 1 2 3 4 5 6 7; do
    s=$(date +%s%N); taskset -c 2 ./$b > /dev/null; e=$(date +%s%N); ms=$(( (e - s) / 1000000 ))
    [ $ms -lt $best ] && best=$ms
  done
  echo "$b best_of_7_ms=$best output=$(cat $b.out)"
done

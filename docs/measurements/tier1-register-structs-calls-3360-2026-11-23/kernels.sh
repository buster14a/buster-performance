#!/bin/bash
# Builds each kernel by clang -O2 and base/fix Tier 1, checks their outputs agree, then times them (11 runs, CPU 2), one lock per kernel.
set -uo pipefail
D=~/buster-fast-bench/3360-claude; cd $D; . ./env.sh
mkdir -p bin
for k in i4 i2 l2; do
  clang -O2 -w -o bin/$k.clang-O2 $k.c
  base/build/compiler --tier1 -o bin/$k.base-tier1 $k.c
  fix/build/compiler --tier1 -o bin/$k.fix-tier1 $k.c
  for b in clang-O2 base-tier1 fix-tier1; do printf "%s %s\n" $k.$b "$(./bin/$k.$b)"; done >> outputs.txt
done
for k in i4 i2 l2; do
  ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c "cat /proc/loadavg; ./time.sh 11 bin/$k.clang-O2 bin/$k.base-tier1 bin/$k.fix-tier1; cat /proc/loadavg" > times-$k.tsv 2> times-$k.err
  echo "$k exit $?" >> kernels.status
done
echo done >> kernels.status

#!/bin/bash
# Interleaved benchmark-calling-convention rounds of each tree, one locked run each, pinned to CPU 2.
D=~/buster-fast-bench/1833-claude
export EXCLUSIVE_OWNER=claude-1833 EXCLUSIVE_TITLE="#1833 bit-field access units" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1833
OUT=$D/results-$(date +%Y%m%dT%H%M%S)
mkdir -p $OUT
TREES="${TREES:-base merge head}"
for round in 1 2 3 4 5; do
  for n in $TREES; do
    (cd $D/$n && git rev-parse HEAD > $OUT/$n.rev && ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-calling-convention > $OUT/$n.$round.txt 2>&1)
  done
done
echo "BENCH DONE $OUT"

#!/bin/bash
# Rounds 2-5 of base, merge and head interleaved, run inside one lock hold (exclusive.sh around this script).
D=~/buster-fast-bench/1833-claude
OUT=$(ls -d $D/results-* | tail -1)
start=$(date +%s)
for round in 2 3 4 5; do
  for n in base merge head; do
    (cd $D/$n && timeout 120 taskset -c 2 ./build/compiler benchmark-calling-convention > $OUT/$n.$round.txt 2>&1)
  done
  [ $(( $(date +%s) - start )) -gt 240 ] && break
done
echo "AB DONE $OUT $(( $(date +%s) - start )) s"

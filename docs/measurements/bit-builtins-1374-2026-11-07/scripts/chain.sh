#!/bin/bash
# #1374: after build-trees.sh (its PID the argument), the kernels' preparation in one hold, the rounds, then the compiles.
set -u
cd ~/buster-fast-bench/1374-opencode
while kill -0 "$1" 2>/dev/null; do sleep 5; done
grep -q '^done$' build-trees.log || { echo "the builds didn't finish"; exit 1; }
export EXCLUSIVE_OWNER=opencode-1374 EXCLUSIVE_TITLE="opencode #1374 bit builtins A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1374
mkdir -p results
~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> results/holds.txt; ./prepare.sh' > prepare.log 2>&1 || { echo "prepare failed"; exit 1; }
echo prepared
./measure.sh > measure.log 2>&1
echo measured
./compile.sh > compile.log 2>&1
echo compiled

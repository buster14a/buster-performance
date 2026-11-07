#!/bin/bash
# #1385: the trees' builds, the kernels' preparation in one hold, the rounds, then the compiles.
set -u
cd ~/buster-fast-bench/1385-opencode
./build-trees.sh > build-trees.log 2>&1
grep -q '^done$' build-trees.log || { echo "the builds didn't finish"; exit 1; }
export EXCLUSIVE_OWNER=opencode-1385 EXCLUSIVE_TITLE="opencode #1385 overflow builtins A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1385
mkdir -p results
~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> results/holds.txt; ./prepare.sh' > prepare.log 2>&1 || { echo "prepare failed"; exit 1; }
echo prepared
./measure.sh > measure.log 2>&1
echo measured
./compile.sh > compile.log 2>&1
echo compiled

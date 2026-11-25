#!/bin/bash
# remerge.sh: the tree at main 67a1324ac (the PR's new base), built as is (main2) and with patches/merged.patch (the PR
# after merging that main), each with test-direct; then the A/B of the two.
set -e
d=~/buster-fast-bench/3586-claude
cd $d/main
git fetch -q origin main
git checkout -q -- .
git checkout -q --detach 67a1324ac
cd $d
./build-variant.sh main2
./build-variant.sh merged merged.patch
grep -h "test-direct\|fail" build-main2.log build-merged.log | tail -6
AB_UNITS="hello six wcwidth sqlite" ./ab.sh 15 main2 merged

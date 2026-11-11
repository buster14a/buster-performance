#!/bin/bash
# After campaign 2: the fixed build's test-parser with clang and test-check-units, one hold each.
B=$HOME/buster-fast-bench/2089-claude
export EXCLUSIVE_OWNER=claude-2089 EXCLUSIVE_TITLE="test-parser limit flake (#2089)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2089
X=~/buster-fast-bench/exclusive.sh
L=$B/logs/c2
until grep -q "^done" $L/steps.txt 2>/dev/null; do sleep 20; done
cd $B/trees/fix
$X taskset -c 2 ./build/compiler test-parser --clang > $L/fix-test-parser-clang.txt 2>&1
echo "fix test-parser --clang $?" >> $L/steps3.txt
$X ./build/compiler test-check-units > $L/fix-test-check-units.txt 2>&1
echo "fix test-check-units $?" >> $L/steps3.txt
echo done >> $L/steps3.txt

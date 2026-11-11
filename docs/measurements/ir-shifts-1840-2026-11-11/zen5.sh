#!/bin/sh
cd ~/buster-fast-bench/1840-claude-b3
export EXCLUSIVE_OWNER=claude-b3-1840 EXCLUSIVE_TITLE="B3 #1840 shifts Zen5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
git rev-parse HEAD > ../1840-claude-b3-scripts/measure.commit
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > ../1840-claude-b3-scripts/measure.out 2> ../1840-claude-b3-scripts/measure.err
echo measure=$? >> ../1840-claude-b3-scripts/measure.err

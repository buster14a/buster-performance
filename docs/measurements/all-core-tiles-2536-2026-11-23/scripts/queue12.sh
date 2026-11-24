#!/bin/bash
# queue12.sh PART: the page policy's tree built, its checks and its pair, then the tree's columns by tiles (an experiment
# switch over the parser's pull request), each a hold of its own.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
git -C main fetch -q origin main:refs/heads/gh-main claude/blissful-cannon-kcl1ed:refs/heads/pr3470 || { echo "fetch failed"; exit 1; }
./setup2.sh 3f4ff4c72faf546928cc5b1c8806a49e4010e00c pages pages1.patch > setup-pages.log 2>&1
grep -q SETUP-DONE setup-pages.log || { echo "setup failed"; exit 1; }
./smoke12.sh pages "${1:?part}" > smoke12.log 2>&1
./run9.sh pages pages-final 3 'base|||' 'm64|64||' 'defer|||--deferred-bodies'
./setup2.sh 0632163005c26b3de47cdb86f1e815d2898e30b4 t2 t2a.patch > setup-t2.log 2>&1
grep -q SETUP-DONE setup-t2.log || { echo "setup t2 failed"; exit 1; }
./run9.sh t2 t2a-pair 3 'tiles|||' 'cols||BUSTER_EXPERIMENT_TILE_COLUMNS=1|'
echo QUEUE-DONE

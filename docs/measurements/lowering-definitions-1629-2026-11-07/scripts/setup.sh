#!/bin/bash
# #1629 on the 9700X: the trees compared, built one per lock hold. main418 is #442's (3bfb4a72 with the old harness);
# main is 53854a7c, the branch's base; c1 the selection, library-loop and zeroing changes; c2 c1 with the runtime names'
# home-bucket probes.
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
old=~/buster-fast-bench/442-claude-rebase
[ -e buster.git ] || ln -s $old/buster.git buster.git
[ -e cts ] || ln -s $old/cts cts
[ -e synthetic ] || ln -s $old/synthetic synthetic
[ -d scripts ] || cp -r $old/scripts scripts
mkdir -p trees
[ -e trees/main418 ] || ln -s $old/trees/main418 trees/main418
base=53854a7c2e5f9b2d48d73c967329597650943a42
LOCK=$HOME/buster-fast-bench/exclusive.sh scripts/build-trees.sh buster.git trees main=$base:now c1=$base:now:$PWD/patches/c1.patch c2=$base:now:$PWD/patches/c2.patch
for t in main c1 c2; do ls -la trees/$t/build/compiler; done
echo setup-done

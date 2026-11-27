#!/bin/bash
# bp-build.sh TREE TAG: a Release build of TREE as the 9700X job builds it, under the host lock; the executable kept as bin/compiler.TAG
set -e
cd ~/buster-fast-bench/3577-claude-splice
mkdir -p bin logs
tree=$1; tag=$2
export EXCLUSIVE_OWNER=claude-session_01TiDLntzjiBRBBPKQphvMQe
export EXCLUSIVE_TITLE="Fix spliced-line conditionals in direct-path skip (#3577 follow-up)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3577
cd $tree
~/buster-fast-bench/exclusive.sh timeout 1200 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../logs/build-$tag.log 2>&1
cp build/compiler ../bin/compiler.$tag
tail -2 ../logs/build-$tag.log

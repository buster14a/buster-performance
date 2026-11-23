#!/bin/bash
# buildwarm.sh TREE TAG: build TREE, copy its compiler, then warm.sh on it.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
TREE=$1; TAG=$2
mkdir -p results/$TAG
(cd $TREE && $X timeout -k 5 1800 ./build.sh --config Release > $D/results/$TAG/build.log 2>&1) || { echo "build failed" >> results/$TAG/status.txt; exit 1; }
cp $TREE/build/compiler compiler-$TAG
./warm.sh $D/compiler-$TAG $TAG 3

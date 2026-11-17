#!/bin/bash
# The whole #2791 run on the 9700X: the trees' builds, the kernels in 5 rounds, then the compile cost.
set -u
cd ~/buster-fast-bench/2791-claude
./setup.sh "$@" > setup.log 2>&1
mkdir -p kernels compile
cp kernels.c bench.c measure.sh kernels/
./kernels/measure.sh $PWD/main $PWD/head 5 > kernels/measure.log 2>&1
./compile.sh > compile/compile.log 2>&1
echo done > all.done

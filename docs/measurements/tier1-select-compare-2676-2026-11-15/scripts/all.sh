#!/bin/bash
# The whole #2676 run on the 9700X: the trees' builds, the kernels in 5 rounds, then the compile cost.
set -u
cd ~/buster-fast-bench/2676-claude
./setup.sh main=1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a head=4ae8c1b5712e2bebc22621e66e6d66d1a7f4cd66 > setup.log 2>&1
mkdir -p kernels compile
cp kernels.c bench.c measure.sh kernels/
cp compile.sh compile/
./kernels/measure.sh $PWD/main $PWD/head 5 > kernels/measure.log 2>&1
./compile/compile.sh 11 main=$PWD/main head=$PWD/head > compile/compile.log 2>&1
echo done > all.done

#!/bin/bash
# The final head's run on the 9700X: its tree's build, the kernels in 5 rounds against main, then the compile cost.
set -u
cd ~/buster-fast-bench/2791-claude
./setup.sh "$@" > setup2.log 2>&1
mkdir -p kernels-final
cp kernels.c bench.c measure.sh kernels-final/
./kernels-final/measure.sh $PWD/main $PWD/final 5 > kernels-final/measure.log 2>&1
./compile2.sh compile-final main final > compile-final.log 2>&1
echo done > all2.done

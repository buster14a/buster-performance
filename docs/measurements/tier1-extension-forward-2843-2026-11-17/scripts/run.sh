#!/bin/bash
# The whole run, detached on the 9700X: the builds, the kernels (11 rounds) and the compile (11 runs, 4 selections each).
dir=$(cd "$(dirname "$0")" && pwd)
B=$(dirname "$dir")
cd $B
"$dir/setup.sh" > setup.log 2>&1
"$dir/kernels.sh" 11 > kernels.log 2>&1
echo "kernels exit $?" >> kernels.log
"$dir/compile.sh" 11 4 > compile.log 2>&1
echo "compile exit $?" >> compile.log
echo finished > run.done

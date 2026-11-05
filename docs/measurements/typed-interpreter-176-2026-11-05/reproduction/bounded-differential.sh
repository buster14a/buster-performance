#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export LD_LIBRARY_PATH=/home/david/buster-fast-bench/176-codex-01a1ac7e/tools/lib
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 bounded generator comparison' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
compiler="$PWD/build/cmake/native-g0/Release/compiler"
for seed in 176 177 178 179; do
    ~/buster-fast-bench/exclusive.sh "$compiler" test-differential --buster "$compiler" --tier0-default --tier1-arg --tier1 --interpreter --csmith /home/david/buster-fast-bench/codex138-tools/bin/csmith --csmith-include /home/david/buster-fast-bench/codex138-tools/include --csmith-arg --max-funcs --csmith-arg 4 --csmith-arg --max-block-depth --csmith-arg 2 --csmith-arg --max-expr-complexity --csmith-arg 6 --yarpgen /home/david/buster-fast-bench/codex138-tools/bin/yarpgen --clang /usr/bin/clang --generator both --seed "$seed" --count 1 --timeout-ms 30000 --revision 4813ca6fe55ec242e7f796a2e0094ed6c34c9f31 --generator-revision 'csmith-0cdc710315cfee9035e22ef4363ca479270d1934;yarpgen-1adb290f453505838f3aa33dc571f292b0c1810f' --output /home/david/buster-fast-bench/176-codex-01a1ac7e/differential > "../bounded-differential-$seed.log" 2>&1
    echo "$seed: $?" >> ../bounded-differential.status
done

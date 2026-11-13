#!/bin/bash
# 0904e73a's build, then sqlite3.c's --tier1 -c by main, fab53452 and 0904e73a (11 runs each), and a profile.
base=~/buster-fast-bench/1382-claude
./build-tree.sh $base/head-0904e73a
grep -q "^build exit 0" $base/head-0904e73a/build.log || { echo "the build failed"; exit 1; }
mkdir -p $base/compile-0904e73a
cp $base/compile3.sh $base/compile-0904e73a/ && ln -sfn $base/kernels/sqlite $base/compile-0904e73a/sqlite
cd $base/compile-0904e73a && ./compile3.sh 11 main=$base/main-b7a95eed fixed=$base/head-fab53452 lean=$base/head-0904e73a > compile.log 2>&1
echo all done

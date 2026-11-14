#!/bin/bash
# fab53452's kernels against main (5 rounds), then sqlite3.c's --tier1 -c by main, c99e239b's tree and fab53452.
base=~/buster-fast-bench/1382-claude
main=$base/main-b7a95eed
queued=$base/head-d6d8d4bb
fixed=$base/head-fab53452
until grep -q "^build exit" $fixed/build.log 2>/dev/null; do sleep 10; done
grep -q "^build exit 0" $fixed/build.log || { echo "the build failed"; exit 1; }
mkdir -p $base/kernels-fab53452
cp $base/kernels/kernels.c $base/kernels/bench.c $base/kernels/measure.sh $base/kernels-fab53452/
cd $base/kernels-fab53452 && ./measure.sh $main $fixed 5 > measure.log 2>&1
cd $base/kernels && cp ~/buster-fast-bench/1382-claude/compile3.sh . && ./compile3.sh 11 main=$main queued=$queued fixed=$fixed > compile.log 2>&1
echo all done

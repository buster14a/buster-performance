#!/bin/bash
# #840's -fsyntax-only instruction delta: -g builds of its base (d11a91d2) and head (af2d9a9b), their counts, and IBS op
# samples to place it by source line.
R=/home/david/.cache/claude-147/ibs840
export CORES_TITLE="solve 147: #840 instruction attribution" CORES_LINK="https://github.com/buster14a/buster/pull/840"
unset CPATH C_INCLUDE_PATH
Q=/home/david/.cache/claude-572/sqlite
: > $R/summary.txt
for t in base head; do
    (cd $R/$t && cores -n 4 -- ./build.sh > $R/build-$t.log 2>&1) || { echo "build $t failed" >> $R/summary.txt; echo done >> $R/summary.txt; exit 1; }
done
for r in 1 2 3; do for t in base head; do
    taskset -c 1 perf stat -x, -e instructions:u -o $R/stat-$t-$r.txt $R/$t/build/compiler -fsyntax-only -I$Q $Q/sqlite3.c
    echo "$t $r $(grep instructions $R/stat-$t-$r.txt | cut -d, -f1)" >> $R/summary.txt
done; done
for r in 1 2 3 4; do for t in base head; do
    taskset -c 1 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 10000 -o $R/ibs-$t-$r.data $R/$t/build/compiler -fsyntax-only -I$Q $Q/sqlite3.c >> $R/record.log 2>&1
done; done
echo done >> $R/summary.txt

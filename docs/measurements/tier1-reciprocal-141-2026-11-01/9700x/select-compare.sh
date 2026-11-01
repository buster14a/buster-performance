#!/usr/bin/env bash
# select-compare.sh: selection's cost on the frozen sqlite3.c, main against the merged head. exp-select-051de9c is main
# 051de9c with benchmark-tier1-select-source grafted on (select-graft.diff: the command's source from 1ea8b02 and its
# two lines in main.c; committed nowhere). Its build, then each path of each tree alone, 3 processes each in turn, each
# one hold of the shared lock, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
./build.sh exp-select-051de9c
grep -q "^exit 0" logs-build/exp-select-051de9c.log || exit 1
out=$PWD/select-compare
mkdir -p $out
for r in 1 2 3; do
    for t in exp-select-051de9c head-cc3387f; do
        for v in select select-scalar; do
            "$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source --only $v $FLAGS -I$Q $Q/sqlite3.c > $out/$t-$v-$r.txt 2>&1; echo \"exit \$?\" >> $out/$t-$v-$r.txt"
        done
    done
done
for f in $out/*-[123].txt; do echo "$(basename $f .txt) $(grep -A1 "^variant" $f | tail -1)"; done > $out/summary.txt
echo done > $out/done

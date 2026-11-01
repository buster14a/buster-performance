#!/usr/bin/env bash
# select-compare.sh BASE HEAD: benchmark-tier1-select-source on the frozen sqlite3.c, each path of each tree alone, 3
# processes each in turn, each one hold of the shared lock, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-remaining/common.sh
out=$PWD/select-compare-$2
mkdir -p $out
for r in 1 2 3; do
    for t in $1 $2; do
        for v in select select-scalar; do
            "$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source --only $v $FLAGS -I$Q $Q/sqlite3.c > $out/$t-$v-$r.txt 2>&1; echo \"exit \$?\" >> $out/$t-$v-$r.txt"
        done
    done
done
for f in $out/*-[123].txt; do echo "$(basename $f .txt) $(grep -A1 "^variant" $f | tail -1)"; done > $out/summary.txt
echo done > $out/done

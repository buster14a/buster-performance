#!/bin/bash
# perf6.sh LABEL...: the front with the window on sqlite3.c (--front-window) under perf stat, CPU 2, a hold of the lock a
# build: cycles, instructions, mispredicted branches, store-to-load interference, first-level misses.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    ./lock.sh bash -c "perf stat -x, -e cycles:u,instructions:u,branch-misses:u,ls_bad_status2.stli_other:u,ls_stlf:u,L1-dcache-load-misses:u -o $out/perf6-stat.txt -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf6-run.txt 2>&1; echo status \$? >> $out/perf6-run.txt"
    echo "== $label"; cat $out/perf6-stat.txt | cut -d, -f1,3 | grep -v "^#" | tr '\n' ' '; echo
    grep -h "the front with the window" $out/perf6-run.txt | cut -c40-170
done
echo perf6 done

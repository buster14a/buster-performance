#!/bin/bash
# perf7.sh LABEL...: the front with the window on sqlite3.c (--front-window) under perf record of mispredicted
# branches, CPU 2, a hold of the lock a build: by symbol, and by address in the busiest symbols.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    data=/dev/shm/claude-2850-tests.perf.data
    ./lock.sh bash -c "perf record -q -e branch-misses:u -c 97 -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf7-run.txt 2>&1; echo status \$? >> $out/perf7-run.txt"
    perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^$' | grep -v "^#" | head -40 > $out/perf7-symbols.txt
    perf script -i $data -F ip,sym 2>/dev/null | awk '{print $1, $2}' | sort | uniq -c | sort -rn | head -400 > $out/perf7-ips.txt
    rm -f $data
done
echo perf7 done

#!/bin/bash
# perf8.sh LABEL...: the front with the window on sqlite3.c (--front-window) under perf record of user cycles, a sample
# every 4,001, CPU 2, a hold of the lock a build: each sampled address of node_front_chunk_window with its count.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    data=/dev/shm/claude-2850-tests.perf.data
    ./lock.sh bash -c "perf record -q -e cycles:u -c 4001 -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf8-run.txt 2>&1; echo status \$? >> $out/perf8-run.txt"
    perf script -i $data -F ip,sym 2>/dev/null | awk '$2 == "node_front_chunk_window" {print $1}' | sort | uniq -c | sort -k2 > $out/perf8-window-ips.txt
    perf script -i $data -F ip,sym 2>/dev/null | awk '{print $2}' | sort | uniq -c | sort -rn | head -30 > $out/perf8-symbols.txt
    rm -f $data
    echo "== $label: $(awk '{s+=$1} END {print s}' $out/perf8-window-ips.txt) samples in node_front_chunk_window"
done
echo perf8 done

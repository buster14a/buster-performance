#!/bin/bash
# perf9.sh LABEL...: the front with the window on sqlite3.c (--front-window) under perf record of user cycles, 24 runs a
# build, each its own hold of the lock and its own period (a deterministic run samples the same places at one period),
# CPU 2: each sampled address of node_front_chunk_window with its count over the runs.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    data=/dev/shm/claude-2850-tests.perf.data
    rm -f $out/perf9-window-ips.raw $out/perf9-symbols.raw
    for i in $(seq 0 23); do
        period=$((60013 + 74 * i))
        ./lock.sh bash -c "perf record -q -e cycles:u -c $period -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf9-run.txt 2>&1; echo status \$? >> $out/perf9-run.txt"
        perf script -i $data -F ip,sym 2>/dev/null | awk '$2 == "node_front_chunk_window" {print $1}' >> $out/perf9-window-ips.raw
        perf script -i $data -F sym 2>/dev/null >> $out/perf9-symbols.raw
        rm -f $data
    done
    sort $out/perf9-window-ips.raw | uniq -c | sort -k2 > $out/perf9-window-ips.txt
    sort $out/perf9-symbols.raw | uniq -c | sort -rn | head -40 > $out/perf9-symbols.txt
    rm -f $out/perf9-window-ips.raw $out/perf9-symbols.raw
    echo "== $label: $(awk '{s+=$1} END {print s}' $out/perf9-window-ips.txt) samples in node_front_chunk_window"
done
echo perf9 done

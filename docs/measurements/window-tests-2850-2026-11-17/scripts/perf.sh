#!/bin/bash
# perf.sh LABEL: the window's tests at reader time on sqlite3.c under perf record, CPU 2, a hold of the lock a run: user
# cycles (a sample every 20,011), L2 data-cache misses and mispredicted branches, each by symbol
# (results/LABEL/perf-EVENT-symbols.txt); and the cycles' run's bytes' pass, loop and chunk by instruction
# (perf-annotate-*.txt).
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
data=/dev/shm/claude-2850-tests.perf.data
for spec in "cycles 20011" "branch-misses 1009" "l2_cache_req_stat.ic_dc_miss_in_l2 1009"; do
    read -r event period <<< "$spec"
    name=${event%%.*}
    ./lock.sh bash -c "perf record -q -e $event:u -c $period -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-tests $sqlite_arguments > $out/perf-$name-run.txt 2>&1; echo status \$? >> $out/perf-$name-run.txt"
    perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^$' | head -60 > $out/perf-$name-symbols.txt
    if [ $event = cycles ]; then
        for symbol in node_tests_window_bytes node_tests_window_chunk node_tests_window_loop; do
            perf annotate -i $data --stdio -s $symbol 2>/dev/null > $out/perf-annotate-$symbol.txt
        done
    fi
done
rm -f $data
wc -l $out/perf-*-symbols.txt $out/perf-annotate-*.txt

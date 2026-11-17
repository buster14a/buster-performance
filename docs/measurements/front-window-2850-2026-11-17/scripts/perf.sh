#!/bin/bash
# perf.sh LABEL: the window at reader time on sqlite3.c under perf record, CPU 2, a hold of the lock a run: user cycles
# (a sample every 20,011: more than the kernel keeps at this rate, so the shares are read, not the counts),
# instructions (40,009) and mispredicted branches (1,009), each by symbol (results/LABEL/perf-EVENT-symbols.txt); and
# the cycles' run's front passes, the names' pass and the kernel's leaves by instruction (perf-annotate-*.txt).
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
data=/dev/shm/claude-2850-window.perf.data
for spec in "cycles 20011" "instructions 40009" "branch-misses 1009"; do
    read -r event period <<< "$spec"
    ./lock.sh bash -c "perf record -q -e $event:u -c $period -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf-$event-run.txt 2>&1; echo status \$? >> $out/perf-$event-run.txt"
    perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^$' | head -90 > $out/perf-$event-symbols.txt
    if [ $event = cycles ]; then
        for symbol in node_front_chunk_window node_front_chunk_lean node_facts_window_names_vector node_front_keep; do
            perf annotate -i $data --stdio -s $symbol 2>/dev/null > $out/perf-annotate-$symbol.txt
        done
    fi
done
rm -f $data
wc -l $out/perf-*-symbols.txt $out/perf-annotate-*.txt

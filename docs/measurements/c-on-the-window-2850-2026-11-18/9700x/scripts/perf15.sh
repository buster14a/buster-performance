#!/bin/bash
# perf15.sh LABEL RUNS: C on the window on sqlite3.c (--window-contexts) under perf record of cycles and of mispredicted
# branches, RUNS runs each, each run its own hold of the lock and its own period, CPU 2: the samples whose address is in
# node_facts_reader_flush (which holds the window's sweeps, inlined), a count an address, in
# results/LABEL/perf15-{cycles,misses}.txt; and the function's code in results/LABEL/perf15-code.txt.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=$2
out=$PWD/results/$label
first=$(nm $out/compiler | awk '$3 == "node_facts_reader_flush" {print $1}')
size=$(nm -S $out/compiler | awk '$4 == "node_facts_reader_flush" {print $2}')
objdump -d --no-show-raw-insn --start-address=0x$first --stop-address=$(printf '0x%x' $((0x$first + 0x$size))) $out/compiler > $out/perf15-code.txt
data=/dev/shm/claude-2850-tests.perf.data
for event in cycles misses; do
    rm -f $out/perf15-$event-raw.txt $out/perf15-$event-totals.txt
    for i in $(seq 0 $((runs - 1))); do
        if [ $event = cycles ]; then spec="cycles:u -c $((10007 + 38 * i))"; else spec="branch-misses:u -c $((23 + 2 * i))"; fi
        ./lock.sh bash -c "perf record -q -e $spec -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts $sqlite_arguments > $out/perf15-run.txt 2>&1; echo status \$? >> $out/perf15-run.txt"
        perf script -i $data -F ip 2>/dev/null | awk -v first="$first" -v size="$size" 'BEGIN { lo = strtonum("0x" first); hi = lo + strtonum("0x" size) } { v = strtonum("0x" $1); total++; if (v >= lo && v < hi) print $1 } END { print "total", total > "/dev/stderr" }' >> $out/perf15-$event-raw.txt 2>> $out/perf15-$event-totals.txt
        rm -f $data
    done
    sort $out/perf15-$event-raw.txt | uniq -c > $out/perf15-$event.txt
    echo "== $label $event: $(wc -l < $out/perf15-$event-raw.txt) samples in node_facts_reader_flush over $runs runs; $(grep -o 'window contexts ticks=.*' $out/perf15-run.txt | cut -c1-200); $(tail -1 $out/perf15-run.txt)"
    rm -f $out/perf15-$event-raw.txt
done
echo perf15 done

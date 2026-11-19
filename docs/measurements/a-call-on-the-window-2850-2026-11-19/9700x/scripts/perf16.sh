#!/bin/bash
# perf16.sh LABEL RUNS FUNCTION: C on the window on sqlite3.c (--window-contexts) under perf record of cycles and of
# mispredicted branches, RUNS runs each, each run its own hold of the lock and its own period, CPU 2: the samples whose
# address is in FUNCTION, a count an address, in results/LABEL/perf16-FUNCTION-{cycles,misses}.txt, each event's total
# samples in results/LABEL/perf16-FUNCTION-totals.txt, and the function's code in results/LABEL/perf16-FUNCTION-code.txt.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=$2; function=$3
out=$PWD/results/$label
first=$(nm $out/compiler | awk -v f="$function" '$3 == f {print $1}')
size=$(nm -S $out/compiler | awk -v f="$function" '$4 == f {print $2}')
test -n "$first" && test -n "$size" || { echo "no $function in $label"; exit 1; }
objdump -d --no-show-raw-insn --start-address=0x$first --stop-address=$(printf '0x%x' $((0x$first + 0x$size))) $out/compiler > $out/perf16-$function-code.txt
data=/dev/shm/claude-2850-tests.perf.data
rm -f $out/perf16-$function-totals.txt
for event in cycles misses; do
    rm -f $out/perf16-$function-$event-raw.txt
    all=0
    for i in $(seq 0 $((runs - 1))); do
        if [ $event = cycles ]; then spec="cycles:u -c $((10007 + 38 * i))"; else spec="branch-misses:u -c $((23 + 2 * i))"; fi
        ./lock.sh bash -c "perf record -q -e $spec -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts $sqlite_arguments > $out/perf16-run.txt 2>&1; echo status \$? >> $out/perf16-run.txt"
        perf script -i $data -F ip 2>/dev/null | awk -v first="$first" -v size="$size" 'BEGIN { lo = strtonum("0x" first); hi = lo + strtonum("0x" size) } { v = strtonum("0x" $1); total++; if (v >= lo && v < hi) print $1 } END { print "total", total > "/dev/stderr" }' >> $out/perf16-$function-$event-raw.txt 2>> $out/perf16-$function-totals.txt
        rm -f $data
    done
    sort $out/perf16-$function-$event-raw.txt | uniq -c > $out/perf16-$function-$event.txt
    echo "== $label $function $event: $(wc -l < $out/perf16-$function-$event-raw.txt) samples in it over $runs runs; $(tail -1 $out/perf16-run.txt)"
    rm -f $out/perf16-$function-$event-raw.txt
done
echo perf16 done

#!/bin/bash
# perf13.sh LABEL RUNS: the front with the window on sqlite3.c (--front-window) under IBS fetch sampling, from the
# build's own file and from a fresh copy of it, RUNS runs each, each run its own hold of the lock and its own period,
# CPU 2: each fetch sample whose address is in node_front_chunk_window, as "ip IbsFetchCtl", in
# results/LABEL/perf13-<file>-samples.txt.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=$2
out=$PWD/results/$label
cp "$out/compiler" "$out/compiler-fresh"
first=$(nm $out/compiler | awk '$3 == "node_front_chunk_window" {print $1}')
size=$(nm -S $out/compiler | awk '$4 == "node_front_chunk_window" {print $2}')
data=/dev/shm/claude-2850-tests.perf.data
for name in compiler compiler-fresh; do
    rm -f $out/perf13-$name-samples.txt
    for i in $(seq 0 $((runs - 1))); do
        period=$((100003 + 746 * i))
        ./lock.sh bash -c "perf record -q -e ibs_fetch/swfilt=1/u -c $period --raw-samples -o $data -- taskset -c 2 $out/$name measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf13-run.txt 2>&1; echo status \$? >> $out/perf13-run.txt"
        perf script -i $data -D 2>/dev/null | awk -v first="$first" -v size="$size" '
            BEGIN { lo = strtonum("0x" first); hi = lo + strtonum("0x" size) }
            /^ibs_fetch_ctl:/ { ctl = $0 }
            /PERF_RECORD_SAMPLE/ { ip = ""; for (i = 1; i <= NF; i++) { if ($i == "period:") ip = $(i - 1) } v = strtonum(ip); if (v >= lo && v < hi) print ip, ctl }' >> $out/perf13-$name-samples.txt
        rm -f $data
    done
    echo "== $label $name: $(wc -l < $out/perf13-$name-samples.txt) fetch samples in node_front_chunk_window over $runs runs; front $(grep -o 'the front with the window: ticks=[0-9]*' $out/perf13-run.txt | grep -o '[0-9]*$')"
done
rm -f "$out/compiler-fresh"
echo perf13 done

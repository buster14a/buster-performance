#!/bin/bash
# perf11.sh RUNS LABEL...: the front with the window on sqlite3.c (--front-window) under IBS op sampling with data
# addresses and the raw registers, RUNS runs a build, each its own hold of the lock and its own period (no run above
# the host's sample rate cap), CPU 2: each sample whose address is in node_front_chunk_window, as
# "ip data-address CompToRetCtr TagToRetCtr IbsOpData3", in results/LABEL/perf11-window-samples.txt, the front's ticks
# of each run in perf11-front.txt, and every symbol's sample count in perf11-symbols.txt.
cd "$(dirname "$0")"
. ./corpora.sh
runs=$1; shift
for label in "$@"; do
    out=$PWD/results/$label
    data=/dev/shm/claude-2850-tests.perf.data
    first=$(nm $out/compiler | awk '$3 == "node_front_chunk_window" {print $1}')
    size=$(nm -S $out/compiler | awk '$4 == "node_front_chunk_window" {print $2}')
    rm -f $out/perf11-window-samples.txt $out/perf11-symbols.raw $out/perf11-front.txt
    for i in $(seq 0 $((runs - 1))); do
        period=$((400009 + 746 * i))
        ./lock.sh bash -c "perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c $period -d -W --raw-samples -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf11-run.txt 2>&1; echo status \$? >> $out/perf11-run.txt"
        perf script -i $data -D 2>/dev/null | awk -v first="$first" -v size="$size" '
            BEGIN { lo = strtonum("0x" first); hi = lo + strtonum("0x" size) }
            /^ibs_op_data:/ { comp = $4; tag = $6 }
            /^ibs_op_data3:/ { d3 = $2 }
            /PERF_RECORD_SAMPLE/ { ip = ""; addr = ""; for (i = 1; i <= NF; i++) { if ($i == "period:") ip = $(i - 1); if ($i == "addr:") addr = $(i + 1) } v = strtonum(ip); if (v >= lo && v < hi) print ip, addr, comp, tag, d3 }' >> $out/perf11-window-samples.txt
        perf script -i $data -F sym 2>/dev/null >> $out/perf11-symbols.raw
        grep -o 'the front with the window: ticks=[0-9]*' $out/perf11-run.txt | grep -o '[0-9]*$' >> $out/perf11-front.txt
        rm -f $data
    done
    sort $out/perf11-symbols.raw | uniq -c | sort -rn | head -40 > $out/perf11-symbols.txt
    rm -f $out/perf11-symbols.raw
    echo "== $label: $(wc -l < $out/perf11-window-samples.txt) samples in node_front_chunk_window over $runs runs"
done
echo perf11 done

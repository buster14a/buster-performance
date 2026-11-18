#!/bin/bash
# perf12.sh LABEL RUNS: the front with the window on sqlite3.c (--front-window) under perf stat, from the build's own
# file and from a fresh copy of it, RUNS runs of each of two sets of user-mode counters, each run its own hold of the
# lock, CPU 2: the instruction side (ITLB by page size, the instruction cache's misses and where they fill from, the op
# cache) beside cycles and the front's own ticks. Files results/LABEL/perf12-<file>-<set>-<n>.txt.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=$2
out=$PWD/results/$label
cp "$out/compiler" "$out/compiler-fresh"
set1=cycles:u,instructions:u,bp_l1_tlb_fetch_hit.if4k:u,bp_l1_tlb_fetch_hit.if2m:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u
set2=cycles:u,ic_tag_hit_miss.instruction_cache_miss:u,ic_cache_fill_l2:u,ic_cache_fill_sys:u,op_cache_hit_miss.op_cache_miss:u,de_src_op_disp.x86_decoder:u
for n in $(seq 1 "$runs"); do
    for name in compiler compiler-fresh; do
        for s in 1 2; do
            events=$set1; [ $s = 2 ] && events=$set2
            f=$out/perf12-$name-$s-$n.txt
            ./lock.sh bash -c "perf stat -x, -e $events -o $f.stat -- taskset -c 2 $out/$name measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $f 2>&1; echo status \$? >> $f"
            echo "$label $name set $s run $n: front $(grep -o 'the front with the window: ticks=[0-9]*' $f | grep -o '[0-9]*$') | $(grep -v '^#' $f.stat | grep -v '^$' | cut -d, -f1,3 | tr '\n' ' ')"
        done
    done
done
rm -f "$out/compiler-fresh"
echo perf12 done

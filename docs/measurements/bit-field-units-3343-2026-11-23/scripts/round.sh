#!/bin/bash
# One round under one hold of the lock: each kernel's variants perf stat'd 5 times on CPU 2 (user mode: cycles,
# instructions, store-to-load conflicts, forwards), in this round's rotation; the busiest processes before and after.
set -euo pipefail
cd ~/buster-fast-bench/1372-3343-claude
round=$1
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > out/busy-before-$round.txt
variants=(base-tier0 head-tier0 base-tier1 head-tier1 base-tier1mem head-tier1mem clang-O0 clang-O2)
events=cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u
count=${#variants[@]}
for k in 0 1 2 3 4; do
    for i in $(seq 0 $((count - 1))); do
        v=${variants[$(( (i + round) % count ))]}
        perf stat -x, -r 5 -e "$events" -o "out/perf-$k-$v-$round.csv" taskset -c 2 "out/bench-$k-$v" 50000000 > "out/result-$k-$v-$round.txt"
    done
    echo "round $round kernel $k"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > out/busy-after-$round.txt

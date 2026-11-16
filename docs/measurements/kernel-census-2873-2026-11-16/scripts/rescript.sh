#!/bin/bash
# rescript.sh FIRST LAST: perf script of recordings FIRST to LAST again (lock.sh ./rescript.sh 0 5), as kernel.sh now
# writes them.
cd "$(dirname "$0")"
out=results/kernel
for ((n = $1; n <= $2; n += 1)); do
    perf script --ns -i "scratch/kernel-$n.data" --show-mmap-events --show-task-events -F comm,pid,tid,time,event,period,ip,sym,dso,addr,data_page_size 2> "$out/script-$n.err" | gzip -1 > "$out/script-$n.txt.gz"
done

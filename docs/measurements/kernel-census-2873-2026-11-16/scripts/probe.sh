#!/bin/bash
# probe.sh: which perf and strace options this host takes (lock.sh ./probe.sh); output to results/probe.txt.
cd "$(dirname "$0")"
mkdir -p results scratch
exec > results/probe.txt 2>&1
set -x
perf record -q -k mono -d --data-page-size -o scratch/probe1.data -e 'cpu/cycles,period=100003/k' -e 'minor-faults/period=1/' --call-graph fp -- ls / > /dev/null
perf script -i scratch/probe1.data -F comm,pid,tid,time,event,period,ip,sym,addr,data_page_size 2>&1 | head -40
perf record -q -k mono -d --data-page-size -o scratch/probe2.data -e 'cpu/cycles,period=100003,call-graph=fp/k' -e 'minor-faults/period=1,call-graph=dwarf,stack-size=8192/' -- ls / > /dev/null
perf script -i scratch/probe2.data -F comm,pid,tid,time,event,ip,sym,dso,addr,data_page_size 2>&1 | head -60
perf script -i scratch/probe2.data --show-mmap-events --show-task-events -F comm,pid,tid,time,event 2>&1 | grep -E "MMAP|COMM|FORK|EXIT" | head -20
perf report -i scratch/probe2.data -D 2>/dev/null | grep -c THROTTLE
strace -f -k -e trace=mmap -o scratch/probe-strace.txt ls / > /dev/null; head -30 scratch/probe-strace.txt
setarch -R true && echo setarch-ok
ls -la /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/ | head

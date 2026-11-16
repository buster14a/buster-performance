#!/bin/bash
# kernel.sh RUN [COMPILES]: COMPILES (6) compiles of sqlite3.c by the census tree under perf record, in one hold of the
# lock (lock.sh ./kernel.sh RUN). Each records the kernel's cycles (period 100003 + 2 * (RUN * COMPILES + i), so that no
# two compiles sample the same instructions) with kernel call chains and the first user frame, and every minor fault
# with its address and the size of the page it mapped; with -k mono, so that the compile's --time-stages laps
# (stage-laps.patch, CLOCK_MONOTONIC) place every sample in its stage. The compile runs on CPU 2 without address-space
# randomization (setarch -R) under waitall, which keeps perf recording until the exit helper has torn the address space
# down; perf itself runs on CPU 4. Then perf script writes each recording as text (gzip) for the reduction.
set -u
cd "$(dirname "$0")"
here=$PWD
run=${1:?a run number}
compiles=${2:-6}
out=results/kernel
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/census/build/compiler
status=0
{ echo "== run $run $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    period=$((100003 + 2 * n))
    taskset -c 4 perf record -q -k mono -d --data-page-size -o "scratch/kernel-$n.data" \
        -e "cpu/cycles,period=$period/k" -e 'minor-faults/period=1,call-graph=no/' --call-graph fp -- \
        taskset -c 2 setarch -R tools/waitall "$compiler" --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-kernel.o \
        2> "$out/stages-$n.txt" > /dev/null || status=1
    echo "compile $n period $period status $status" >> "$out/host.txt"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    perf script --ns -i "scratch/kernel-$n.data" --show-mmap-events --show-task-events -F comm,pid,tid,time,event,period,ip,sym,dso,addr,data_page_size 2> "$out/script-$n.err" | gzip -1 > "$out/script-$n.txt.gz" || status=1
    perf report -i "scratch/kernel-$n.data" -D 2> /dev/null | grep -c -E 'PERF_RECORD_(THROTTLE|LOST)' > "$out/throttle-$n.txt"
done
sha256sum "$compiler" >> "$out/host.txt"
rm -f /dev/shm/2873-kernel.o
exit $status

#!/bin/bash
# reads.sh RUN [COMPILES]: COMPILES (4) compiles of sqlite3.c by the census tree under perf record of IBS op samples
# (Zen 5's instruction-based sampling: one op in 400,009 + 2n dispatched, user mode only), each with its data address and
# whether it loaded or stored, for which stages read each owner's memory again (item 2); as kernel.sh otherwise (CPU 2,
# setarch -R, waitall, -k mono, the mmap records). In one hold of the lock (lock.sh ./reads.sh RUN).
set -u
cd "$(dirname "$0")"
here=$PWD
run=${1:?a run number}
compiles=${2:-4}
out=results/reads
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/census/build/compiler
status=0
{ echo "== run $run $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    period=$((400009 + 2 * n))
    taskset -c 4 perf record -q -k mono -d -o "scratch/reads-$n.data" -e "ibs_op/cnt_ctl=1,swfilt=1/u" -c "$period" -- \
        taskset -c 2 setarch -R tools/waitall "$compiler" --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-reads.o \
        2> "$out/stages-$n.txt" > /dev/null || status=1
    echo "compile $n period $period status $status" >> "$out/host.txt"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    perf script --ns -i "scratch/reads-$n.data" --show-mmap-events --show-task-events -F comm,pid,tid,time,event,period,addr,data_src,ip,sym 2> "$out/script-$n.err" | gzip -1 > "$out/script-$n.txt.gz" || status=1
    perf report -i "scratch/reads-$n.data" -D 2> /dev/null | grep -c -E 'PERF_RECORD_(THROTTLE|LOST)' > "$out/throttle-$n.txt"
done
rm -f /dev/shm/2873-reads.o
exit $status

#!/bin/bash
# faults.sh RUN [COMPILES]: COMPILES (2) compiles of sqlite3.c by the census tree under perf record, every minor fault with
# its address, page size and the user stack's DWARF unwinding (16 KB of stack), for the code that first touches each page
# where its instruction is a C library's (memset, memmove); as kernel.sh otherwise (CPU 2, setarch -R, waitall, -k mono).
# In one hold of the lock (lock.sh ./faults.sh RUN).
set -u
cd "$(dirname "$0")"
here=$PWD
run=${1:?a run number}
compiles=${2:-2}
out=results/faults
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/census/build/compiler
status=0
{ echo "== run $run $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    taskset -c 4 perf record -q -m 16384 -k mono -d --data-page-size -o "scratch/faults-$n.data" \
        -e 'minor-faults/period=1,call-graph=dwarf,stack-size=16384/' -- \
        taskset -c 2 setarch -R tools/waitall "$compiler" --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-faults.o \
        2> "$out/stages-$n.txt" > /dev/null || status=1
    echo "compile $n status $status" >> "$out/host.txt"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
for ((i = 0; i < compiles; i += 1)); do
    n=$((run * compiles + i))
    perf script --ns -i "scratch/faults-$n.data" --show-mmap-events --show-task-events -F comm,pid,tid,time,event,period,ip,sym,dso,addr,data_page_size 2> "$out/script-$n.err" | gzip -1 > "$out/script-$n.txt.gz" || status=1
done
rm -f /dev/shm/2873-faults.o
exit $status

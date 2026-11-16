#!/bin/bash
# cputotals.sh ROUNDS: CPU 2's own counts over whole commands (perf stat -C 2), which hold what a task's counters miss
# on Linux 6.18: its exit's teardown of its address space, which do_exit runs after it has stopped the task's events.
# Each command runs on CPU 2 under waitall (a child subreaper, which waits for the exit helper), perf on CPU 4; each line
# 5 times a round, the lines in turn, ROUNDS rounds; in one hold of the lock (lock.sh ./cputotals.sh 3).
set -u
cd "$(dirname "$0")"
here=$PWD
rounds=${1:-3}
out=results/cputotals
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/src/build/compiler
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
events=cycles:k,cycles:u,instructions:k,instructions:u,page-faults,context-switches
stamp=$(date -u +%Y%m%dT%H%M%SZ)
status=0
{ echo "== $stamp"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
line()
{
    local label=$1
    shift
    taskset -c 4 perf stat -C 2 -x, -r 5 -e "$events" -o "$out/$stamp-$label-$round.csv" -- taskset -c 2 tools/waitall "$@" > /dev/null 2>&1 || status=1
}
for ((round = 0; round < rounds; round += 1)); do
    line sqlite "$compiler" -c "${options[@]}" -o /dev/shm/2873-cputotals.o
    line sqlite-no-helper env BUSTER_EXIT_HELPER=0 "$compiler" -c "${options[@]}" -o /dev/shm/2873-cputotals.o
    line syntax "$compiler" -fsyntax-only "${options[@]}"
    line empty "$compiler" -c inputs/empty.c -o /dev/shm/2873-cputotals-empty.o
    line dumpversion "$compiler" -dumpversion
    line true /usr/bin/true
done
{ echo "status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
rm -f /dev/shm/2873-cputotals*.o
exit $status

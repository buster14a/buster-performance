#!/bin/bash
# t1.sh: what the page cache's huge pages do to a compile's faults in the executable, on a fresh copy of main's
# executable: the fault maps and CPU 2's counts (perf stat -C 2, 8 compiles of sqlite3.c and one pass of musl's units a
# process each) before and after tools/collapse collapses the file's read-only and code segments' whole 2 MB ranges.
# One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
out=results/t1
mkdir -p "$out"
cp main/build/compiler "$out/compiler"
c=$here/$out/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host.txt"
compile() { taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o; }
phase()
{
    local name=$1
    tools/collapse "$c" check 0 0x2ff4000 > "$out/$name-check.txt"
    ./faultmap.sh "$out/$name-sqlite" "$c" sqlite
    ./faultmap.sh "$out/$name-empty" "$c" empty
    ./faultmap.sh "$out/$name-musl" "$c" musl
    for i in 0 1 2 3 4 5 6 7; do
        taskset -c 4 perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults -o "$out/$name-sqlite-$i.csv" -- taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
            -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o
    done
    for i in 0 1; do
        taskset -c 4 perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults -o "$out/$name-musl-$i.csv" -- taskset -c 2 bash ../scripts/musl-loop.sh units "$c" > /dev/null 2> "$out/$name-musl-$i.err"
    done
}
for i in 1 2 3; do compile; done
phase before
tools/collapse "$c" collapse 0 0x2ff4000 > "$out/collapse.txt" 2>&1
phase after
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
rm -f /dev/shm/2873-p1.o

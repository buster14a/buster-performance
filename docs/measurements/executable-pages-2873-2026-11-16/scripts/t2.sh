#!/bin/bash
# t2.sh TREE OUT CODE_END DATA_END: what the page cache's huge pages do to a compile's faults in the executable, on a
# fresh copy of TREE's executable: the fault maps and CPU 2's counts (perf stat -C 2, 8 compiles of sqlite3.c and two
# passes of musl's units a process each) in three phases: as copied (`before`); after tools/collapse collapses the whole
# 2 MB ranges of the file's bytes to CODE_END, its read-only and code segments (`code`); and after it collapses those
# from there to DATA_END, its data segments' (`data`). One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
tree=$1
out=$2
code_end=$3
data_end=$4
mkdir -p "$out"
cp "$tree/build/compiler" "$out/compiler"
c=$here/$out/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host.txt"
compile() { taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o; }
phase()
{
    local name=$1
    tools/collapse "$c" check 0 "$data_end" > "$out/$name-check.txt"
    ./faultmap.sh "$out/$name-sqlite" "$c" sqlite
    ./faultmap.sh "$out/$name-empty" "$c" empty
    ./faultmap.sh "$out/$name-musl" "$c" musl
    for i in 0 1 2 3 4 5 6 7; do
        taskset -c 4 perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults,iTLB-load-misses -o "$out/$name-sqlite-$i.csv" -- taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
            -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o
    done
    for i in 0 1; do
        taskset -c 4 perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults,iTLB-load-misses -o "$out/$name-musl-$i.csv" -- taskset -c 2 bash ../scripts/musl-loop.sh units "$c" > /dev/null 2> "$out/$name-musl-$i.err"
    done
}
for i in 1 2 3; do compile; done
phase before
tools/collapse "$c" collapse 0 "$code_end" > "$out/collapse-code.txt" 2>&1
phase code
tools/collapse "$c" collapse "$code_end" "$data_end" > "$out/collapse-data.txt" 2>&1
phase data
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
rm -f /dev/shm/2873-p1.o

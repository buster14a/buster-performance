#!/bin/bash
# first.sh TREE OUT [COPY]: a new executable's first runs: a fresh copy of TREE's executable (cp, a reflink; with COPY
# `written`, cp --reflink=never, whose pages wait to be written back as a build's or an install's do), then 8 compiles
# of sqlite3.c one after the other, each counted on CPU 2 as a whole (perf stat -C 2), with how much of the copy the
# page cache holds in huge pages after each (tools/collapse check). Then the same of a second fresh copy with musl's
# first 24 units, a process each. OUT/sqlite-N.csv, OUT/musl-N.csv, OUT/pagecache.txt. One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ../scripts/musl-common.sh
tree=$1
out=$2
how=${3:-reflink}
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
events=cycles:k,cycles:u,instructions:u,page-faults,iTLB-load-misses
copy() { if [ "$how" = written ]; then cp --reflink=never "$tree/build/compiler" "$1"; else cp "$tree/build/compiler" "$1"; fi; }
: > "$out/pagecache.txt"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host.txt"
c=$here/$out/sqlite.compiler
copy "$c"
for i in 0 1 2 3 4 5 6 7; do
    taskset -c 4 perf stat -C 2 -x, -e "$events" -o "$out/sqlite-$i.csv" -- taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-first.o 2> /dev/null
    echo "sqlite $i $(tools/collapse "$c" check 0 0x3000000 | sed 's/.*: //')" >> "$out/pagecache.txt"
done
c=$here/$out/musl.compiler
copy "$c"
for i in $(seq 0 23); do
    taskset -c 4 perf stat -C 2 -x, -e "$events" -o "$out/musl-$i.csv" -- taskset -c 2 ../tools/waitall "$c" "${options[@]}" -c "${files[$i]}" -o /dev/shm/2873-first.o 2> /dev/null
    echo "musl $i $(tools/collapse "$c" check 0 0x3000000 | sed 's/.*: //')" >> "$out/pagecache.txt"
done
{ date -u; cat /proc/loadavg; } >> "$out/host.txt"
rm -f "$out"/*.compiler /dev/shm/2873-first.o

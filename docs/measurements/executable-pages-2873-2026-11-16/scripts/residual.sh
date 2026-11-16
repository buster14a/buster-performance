#!/bin/bash
# residual.sh TREE OUT: the faults a compile still takes in TREE's executable once the page cache holds it as the exit
# helper leaves it: a fresh copy, six compiles of sqlite3.c to warm it, then the fault maps (faultmap.sh) of sqlite3.c,
# an empty file and four of musl's units. One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
tree=$1
out=$2
mkdir -p "$out"
cp "$tree/build/compiler" "$out/compiler"
c=$here/$out/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for i in 1 2 3 4 5 6; do
    taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o
done
sleep 1
tools/collapse "$c" check 0 0x4400000 > "$out/pagecache.txt"
./faultmap.sh "$out/sqlite" "$c" sqlite
./faultmap.sh "$out/empty" "$c" empty
./faultmap.sh "$out/musl" "$c" musl
rm -f "$out/compiler" /dev/shm/2873-p1.o

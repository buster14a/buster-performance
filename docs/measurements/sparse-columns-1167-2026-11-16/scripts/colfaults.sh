#!/bin/bash
# colfaults.sh OUT COMPILER: one -c sqlite3.c (the census's options) by a tree with columns.patch, BUSTER_1167_COLUMNS=OUT
# (the columns' addresses, no dump), under perf record of every minor fault with its address, on CPU 2; then faultcols's
# table (OUT/faults.tsv). One hold of the lock.
set -u
cd "$(dirname "$0")"
out=$1
compiler=$2
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
BUSTER_1167_COLUMNS="$PWD/$out" perf record -q -e minor-faults -c 1 -d -o "$out/perf.data" -- taskset -c 2 "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION \
    -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/1167-colfaults.o 2> "$out/stderr.txt"
status=$?
rm -f /dev/shm/1167-colfaults.o
perf script -i "$out/perf.data" -F comm,addr 2> /dev/null | awk '$1 == "compiler" {print $2}' > "$out/addresses.txt"
tools/faultcols "$out/columns.txt" "$out/addresses.txt" > "$out/faults.tsv" || status=1
rm -f "$out/perf.data"
exit $status

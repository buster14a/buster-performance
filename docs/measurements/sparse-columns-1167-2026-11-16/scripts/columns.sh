#!/bin/bash
# columns.sh OUT [COMPILER]: one compile of sqlite3.c (the census's options) by the census tree with
# BUSTER_1167_COLUMNS=OUT: the rare columns' addresses (OUT/columns.txt) and the arena's pushed bytes at the reading's
# end (OUT/sparse.bin); then sparsecols's table (OUT/columns.tsv). CPU 2. In one hold of the lock (lock.sh ./columns.sh).
set -u
cd "$(dirname "$0")"
out=$1
compiler=${2:-$PWD/census/build/compiler}
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
BUSTER_1167_COLUMNS="$PWD/$out" BUSTER_1167_DUMP=1 taskset -c 2 "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
    -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/1167-columns.o 2> "$out/stderr.txt"
status=$?
rm -f /dev/shm/1167-columns.o
tools/sparsecols "$out/columns.txt" "$out/sparse.bin" > "$out/columns.tsv" || status=1
exit $status

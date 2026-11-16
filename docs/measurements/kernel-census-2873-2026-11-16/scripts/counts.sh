#!/bin/bash
# counts.sh: the system calls of one compile of sqlite3.c by main's build (strace -f -c: each call's count, and the
# time strace's tracing gives it, which is not the kernel's time untraced), and tools/pagecost's file cases on the corpus's
# own sqlite3.c (its page cache as the compiles find it, not a fresh copy's); CPU 2. In one hold (lock.sh ./counts.sh).
set -u
cd "$(dirname "$0")"
here=$PWD
out=results/counts
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
status=0
taskset -c 2 strace -f -c -o "$out/strace-c.txt" tools/waitall "$here/src/build/compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-counts.o > /dev/null 2>&1 || status=1
taskset -c 2 strace -f -o "$out/strace-calls.txt" -e trace=openat,open,stat,newfstatat,fstat,statx,readlink,readlinkat,getdents64,access,pread64,read \
    "$here/src/build/compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" \
    "$sqlite/sqlite3.c" -o /dev/shm/2873-counts.o > /dev/null 2>&1 || status=1
taskset -c 2 tools/pagecost --reps 9 --case file-map --case file-populate --case file-read-fresh --case file-read-reused "$sqlite/sqlite3.c" /dev/shm \
    > "$out/pagecost-corpus.tsv" 2>> "$out/pagecost-corpus.err" || status=1
rm -f /dev/shm/2873-counts.o
exit $status

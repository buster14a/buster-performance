#!/bin/bash
# memsets.sh: one compile of sqlite3.c by the census tree under gdb (which runs it without address-space randomization,
# as setarch -R does), with scripts/memsets.gdb; CPU 2, --time-stages as the recorded compiles. In one hold of the lock
# (lock.sh ./memsets.sh).
set -u
cd "$(dirname "$0")"
here=$PWD
out=results/memsets
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
status=0
taskset -c 2 timeout -k 5 200 gdb -nx -q -batch -x scripts/memsets.gdb --args "$here/census/build/compiler" --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION \
    -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-memsets.o \
    > "$out/memsets.txt" 2> "$out/stderr.txt" || status=1
grep -c -P '^mem(set|move)\t' "$out/memsets.txt" >> "$out/stderr.txt"
rm -f /dev/shm/2873-memsets.o
exit $status

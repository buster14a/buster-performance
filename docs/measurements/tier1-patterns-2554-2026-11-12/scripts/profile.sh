#!/bin/bash
# profile.sh NAME: perf record of src-NAME's --tier1 -c of speedtest1's unity file, five times, pinned to CPU 2; the
# report's symbols with at least 0.1% of the samples. Run inside one hold of the lock. results/profile-NAME.txt.
set -u
cd "$(dirname "$0")"
name=$1
work=$PWD/scratch/profile
mkdir -p "$work" results
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> results/holders.txt
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
compiler=$PWD/src-$name/build/compiler
for k in 1 2 3 4 5; do
    taskset -c 2 perf record -q -F 20000 -e cycles:u -o "$work/perf-$name-$k.data" -- "$compiler" --tier1 -fno-asynchronous-unwind-tables -c -DSQLITE_OMIT_LOAD_EXTENSION \
        -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" -o "$work/speedtest1-$name.o" "$work/speedtest1-unity.c" > /dev/null 2>&1
done
for k in 1 2 3 4 5; do
    perf report -q -i "$work/perf-$name-$k.data" --sort symbol --percent-limit 0.1 2>/dev/null
done > "results/profile-$name.txt"

#!/bin/bash
# Cycle profiles of the base, nodom and h7 compilers on sqlite3.c's Tier 1 -c (#2553).
set -u
cd ~/buster-fast-bench/2553-claude
mkdir -p compile
for rev in base nodom h7
do
    perf record -q -e cycles:u -c 200003 -o compile/$rev.perf.data -- taskset -c 2 $rev/build/compiler --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c inputs/sqlite/sqlite3.c -o /tmp/claude-2553-$rev.o
    perf report -q -i compile/$rev.perf.data --sort symbol --stdio 2>/dev/null | head -80 > compile/$rev.perf.txt
    rm -f /tmp/claude-2553-$rev.o
done

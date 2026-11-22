#!/bin/bash
# #3298: sqlite3.c -c --tier1 with the tables pass (the default) and without it (--tier1-passes=-tables), the same
# Release build, by time-runs' Williams design on CPU 2; then each one's --tier1-report.
cd "$(dirname "$0")"
corpus=$PWD/corpus
B=$PWD/buster/build/compiler
flags=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc
       -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
echo "commit $(git -C buster rev-parse HEAD)"
for passes in "" "--tier1-passes=-tables"; do
    echo "report $passes"
    $B --tier1 --tier1-report $passes -c "${flags[@]}" -o /tmp/3298-sqlite.o "$corpus/sqlite/sqlite3.c" 2>&1 | tr '\t' '\n' | grep -E "^(functions|compiled|records|value_tables)=" | tr '\n' ' '
    echo
    size /tmp/3298-sqlite.o | tail -1
done
taskset -c 2 $B time-runs --runs 11 --warmups 1 --executable "$B" \
    --list --tier1 -c "${flags[@]}" -o /tmp/3298-a.o "$corpus/sqlite/sqlite3.c" \
    --list --tier1 --tier1-passes=-tables -c "${flags[@]}" -o /tmp/3298-b.o "$corpus/sqlite/sqlite3.c"
rm -f /tmp/3298-sqlite.o /tmp/3298-a.o /tmp/3298-b.o

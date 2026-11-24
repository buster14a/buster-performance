#!/bin/bash
# #1340 part 3: where the root loop's cycles are, by symbol, for each variant: eight `perf record` runs of the
# `--lanes 1 -c` compile of sqlite3.c each, alternating. One hold. Usage: roots-prof.sh NAME VARIANT...
set -u
name=$1; shift
B=$HOME/buster-fast-bench/1340-roots/bin
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$HOME/buster-fast-bench/1340-roots/results/$name
rm -rf "$out"; mkdir -p "$out"; cd "$out" || exit 1
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for i in 1 2 3 4 5 6 7 8; do
    for v in "$@"; do
        taskset -c 2 perf record -q -e cycles:u -c 20011 -o "perf-$v-$i.data" -- "$B/compiler-$v" "${O[@]}" -o x.o > /dev/null 2>&1
    done
done
rm -f x.o
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > after.txt
echo done > held

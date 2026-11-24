#!/bin/bash
# A cycles profile of the sqlite3.c compile by each binary, by function: eight perf record runs each, alternating.
# Run under the lock. Arguments: a label, then the binaries' names.
set -u
cd ~/buster-fast-bench/1340-reach
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
label=$1; shift
out=$PWD/results/prof-$label
rm -rf "$out"; mkdir -p "$out"; cd "$out"
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
{ date -u; cat /proc/loadavg; } > before.txt
for round in 1 2 3 4 5 6 7 8; do
    for name in "$@"; do
        taskset -c 2 perf record -q -e cycles:u -c 20011 -o "perf-$name-$round.data" -- ../../bin/compiler-$name "${O[@]}" -o x.o > /dev/null 2>> "err-$name.txt"
    done
done
for name in "$@"; do
    for round in 1 2 3 4 5 6 7 8; do perf report -q -i "perf-$name-$round.data" --sort symbol --stdio 2>/dev/null | awk '{ print $1, $NF }'; done |
        awk '{ gsub("%", "", $1); sum[$2] += $1 } END { for (s in sum) printf "%8.3f %s\n", sum[s] / 8, s }' | sort -rn > "by-function-$name.txt"
done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete

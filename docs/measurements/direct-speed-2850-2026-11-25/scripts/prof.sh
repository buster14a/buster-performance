#!/bin/bash
# prof.sh NAME: cycles by function and by line for bin/direct-NAME (40 compiles), one hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-r9uggb
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
taskset -c 2 perf record -q -e cycles:u -c 20011 -o "$out/cycles.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 > /dev/null 2>&1
perf report -i "$out/cycles.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -70 > "$out/cycles.txt"
perf report -i "$out/cycles.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -400 > "$out/cycles-lines.txt"
taskset -c 2 perf record -q -e ex_ret_brn_misp:u -c 211 -o "$out/bmiss.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 > /dev/null 2>&1
perf report -i "$out/bmiss.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -50 > "$out/bmiss.txt"
perf report -i "$out/bmiss.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -300 > "$out/bmiss-lines.txt"
taskset -c 2 perf stat -e cycles:u,cycles:k,instructions:u,branches:u,ex_ret_brn_misp:u,L1-dcache-load-misses:u,page-faults -o "$out/stat40.txt" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 --summary > "$out/summary.txt" 2>&1
rm -f /dev/shm/r9uggb.o

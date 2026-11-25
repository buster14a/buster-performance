#!/bin/bash
# lbr.sh NAME: branch records (AMD LBR) sampled on cycles for bin/direct-NAME: counts of taken branches and of
# mispredicted ones by source address. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-r9uggb
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
taskset -c 2 perf record -q -b -e cycles:u -c 100003 -o "$out/lbr.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 > "$out/lbr.log" 2>&1
perf script -i "$out/lbr.data" -F brstack 2> /dev/null | tr ' ' '\n' | awk -F/ 'NF>=3 {t[$1]++; if ($3=="M") m[$1]++} END{for (a in t) printf "%s %d %d\n", a, t[a], m[a]+0}' | sort -k3 -n -r > "$out/lbr-branches.txt"
wc -l "$out/lbr-branches.txt"; tail -2 "$out/lbr.log"
rm -f /dev/shm/r9uggb.o

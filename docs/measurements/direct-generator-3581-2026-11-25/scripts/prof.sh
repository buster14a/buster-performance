#!/bin/bash
# prof.sh NAME: cycles, instructions and mispredicted branches by symbol, 40 compiles of sqlite3.c, CPU 2. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/3581-claude-hape45
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
for ev in cycles:u instructions:u ex_ret_brn_misp:u; do
  tag=$(echo "$ev" | tr -c 'a-zA-Z0-9\n' '_')
  per=100003; [ "$ev" = ex_ret_brn_misp:u ] && per=1009
  taskset -c 2 perf record -q -e "$ev" -c "$per" -o "$out/$tag.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/hape45.o --repeat 40 > /dev/null 2>&1
  perf report -i "$out/$tag.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/$tag.txt"
done
rm -f /dev/shm/hape45.o

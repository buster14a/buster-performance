#!/bin/bash
# ev.sh NAME EVENT PERIOD: samples of EVENT by symbol and by symbol+srcline for bin/direct-NAME (40 compiles). One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-r9uggb
n=$1; ev=$2; per=$3
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
tag=$(echo "$ev" | tr -c 'a-zA-Z0-9\n' '_')
taskset -c 2 perf record -q -e "$ev" -c "$per" -o "$out/$tag.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 > /dev/null 2>&1
perf report -i "$out/$tag.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -40 > "$out/$tag.txt"
perf report -i "$out/$tag.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -150 > "$out/$tag-lines.txt"
rm -f /dev/shm/r9uggb.o

#!/bin/bash
# prof2.sh NAME: instructions and mispredicts by symbol+srcline for bin/direct-NAME (40 compiles), one hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-r9uggb
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
taskset -c 2 perf record -q -e instructions:u -c 50021 -o "$out/instr.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40 > /dev/null 2>&1
perf report -i "$out/instr.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | zstd -3 > "$out/instr-lines.zst"
perf report -i "$out/bmiss.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | zstd -3 > "$out/bmiss-lines.zst"
perf report -i "$out/cycles.data" --no-children --sort symbol,srcline -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | zstd -3 > "$out/cycles-lines.zst"
rm -f /dev/shm/r9uggb.o

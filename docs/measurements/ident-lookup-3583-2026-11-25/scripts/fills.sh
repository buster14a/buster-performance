#!/bin/bash
# fills.sh NAME...: demand data fills by source (L2, L3 in the CCX, DRAM) per compile of sqlite3.c, CPU 2, 20 compiles
# a process.
set -uo pipefail
here=$HOME/buster-fast-bench/3583-ident-lookup
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/fills-3583.XXXXXX)
for n in "$@"; do
    taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u,ls_dmnd_fills_from_sys.dram_io_all:u,ls_any_fills_from_sys.all:u,l2_cache_req_stat.ls_rd_blk_c:u -o "$tmp/$n.csv" -- \
        "$here/bin/direct-$n" "${hargs[@]}" -o "$tmp/out.o" --repeat 20 > /dev/null 2>&1
    printf '%-12s' "$n"; awk -F';' '{printf " %s=%.0f", $3, $1/20}' "$tmp/$n.csv"; echo
done
rm -rf "$tmp"

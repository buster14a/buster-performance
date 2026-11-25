#!/bin/bash
# prof.sh NAME: perf samples (cycles, mispredicts, L1 data misses) of bin/direct-NAME's compiles of sqlite3.c, CPU 2,
# annotated for fast_pp_drain.
set -uo pipefail
here=$HOME/buster-fast-bench/3583-ident-lookup
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/prof-3583.XXXXXX)
for ev in cycles:u ex_ret_brn_misp:u; do
    taskset -c 2 perf record -q -e "$ev" -c 2003 -o "$tmp/p.data" -- "$here/bin/direct-$n" "${hargs[@]}" -o "$tmp/out.o" --repeat 30 > /dev/null 2>&1
    perf report -i "$tmp/p.data" --stdio --no-children --sort sym 2>/dev/null | grep -v '^#' | grep -v '^$' | head -25 > "$here/results/prof-$n-${ev%%:*}.syms.txt"
    for fn in ${FUNCS:-fast_pp_drain}; do
        perf annotate -i "$tmp/p.data" --stdio -l --no-source "$fn" 2>/dev/null > "$here/results/prof-$n-${ev%%:*}.$fn.txt"
    done
done
rm -rf "$tmp"

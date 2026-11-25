#!/bin/bash
# ic.sh NAME: instruction-cache fills by function, and hot code lines, for bin/direct-NAME. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-r9uggb
n=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
out=$here/results/$n; mkdir -p "$out"
run=(taskset -c 2 "$here/bin/direct-$n" "${hargs[@]}" -o /dev/shm/r9uggb.o --repeat 40)
perf record -q -e ic_cache_fill_l2:u -c 211 -o "$out/icfill.data" -- "${run[@]}" > /dev/null 2>&1
perf report -i "$out/icfill.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -40 > "$out/icfill.txt"
perf script -i "$out/icfill.data" -F ip,sym 2>/dev/null | awk '{printf "%s %s\n", substr($1,1,length($1)-1), $2}' | sort | uniq -c | sort -rn > "$out/icfill-lines.txt"
perf script -i "$out/cycles.data" -F ip,sym 2>/dev/null | awk '{ip=strtonum("0x"$1); printf "%x %s\n", int(ip/64), $2}' | sort | uniq -c | sort -rn > "$out/cycle-lines64.txt"
perf stat --all-user -x ';' --no-big-num -e de_src_op_disp.op_cache,de_src_op_disp.x86_decoder,de_op_queue_empty,ic_tag_hit_miss.instruction_cache_miss,ic_cache_fill_l2,ic_cache_fill_sys -o "$out/frontend.csv" -- "${run[@]}" > /dev/null 2>&1
perf stat --all-user -x ';' --no-big-num -e de_no_dispatch_per_slot.no_ops_from_frontend,de_no_dispatch_per_slot.backend_stalls,de_src_op_disp.all,ex_ret_ops,cycles,bp_redirects.ex_redir -o "$out/slots.csv" -- "${run[@]}" > /dev/null 2>&1
rm -f /dev/shm/r9uggb.o

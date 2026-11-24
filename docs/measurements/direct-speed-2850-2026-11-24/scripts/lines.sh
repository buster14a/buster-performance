#!/bin/bash
# lines.sh NAME: source lines of bin/direct-NAME's hottest functions by event: forwarding failures, mispredicted
# branches, cycles, op-cache-miss decoder ops. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
name=$1
out=$here/results/$name/lines
mkdir -p "$out"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
obj=/dev/shm/direct-tx5wvj-$name.l.o
run=(taskset -c 2 "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 60)
rec() { # rec FILE EVENT PERIOD
    perf record -q -e "$2" -c "$3" -o "$out/$1.data" -- "${run[@]}" > /dev/null 2>&1
    perf report -i "$out/$1.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | grep -v '^#' | head -40 > "$out/$1.functions.txt"
    for f in $(awk '{print $3}' "$out/$1.functions.txt" | head -14); do
        echo "== $f"
        perf annotate -i "$out/$1.data" --stdio -l -s "$f" 2> /dev/null | grep -E '^\s+[0-9]+\.[0-9]+ +[a-z_0-9]+\.[ch]:[0-9]+' | sort -rn | head -22
    done > "$out/$1.lines.txt"
    rm -f "$out/$1.data"
}
rec stlf ls_bad_status2.stli_other:u 101
rec bmiss ex_ret_brn_misp:u 101
rec cycles cycles:u 10007
rec decoder de_src_op_disp.x86_decoder:u 5003
rm -f "$obj"
echo done > "$out/done"

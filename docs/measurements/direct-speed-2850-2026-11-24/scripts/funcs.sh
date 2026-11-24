#!/bin/bash
# funcs.sh NAME...: bin/direct-NAME's cycles, instructions and mispredicted branches by function (60 compiles), a hold.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
for name in "$@"; do
    out=$here/results/$name; mkdir -p "$out"
    obj=/dev/shm/direct-tx5wvj-$name.f.o
    for ev in cycles:u:10007 ex_ret_instr:u:25013 ex_ret_brn_misp:u:101 ls_bad_status2.stli_other:u:101; do
        e=${ev%:*}; c=${ev##*:}; tag=${e%%:*}
        perf record -q -e "$e" -c "$c" -o "$out/f-$tag.data" -- taskset -c 2 "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 60 > /dev/null 2>&1
        perf report -i "$out/f-$tag.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | grep -v '^#' | head -45 | awk '{printf "%s %s\n", $1, $3}' > "$out/f-$tag.txt"
    done
    rm -f "$obj"
    echo "== $name"
    paste "$out/f-cycles.txt" "$out/f-ex_ret_instr.txt" "$out/f-ex_ret_brn_misp.txt" "$out/f-ls_bad_status2.stli_other.txt" | head -34 | awk '{printf "%7s %-34s %7s %-34s %7s %-34s %7s %s\n", $1,$2,$3,$4,$5,$6,$7,$8}'
done

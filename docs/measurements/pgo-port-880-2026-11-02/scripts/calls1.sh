#!/usr/bin/env bash
# Sampled returns of tree-base's and tree-pgo's compilers with their LBR records (any_ret): callee -> caller edges.
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
O=$R/calls1
rm -rf "$O"; mkdir -p "$O"; cd "$O"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
for v in base pgo; do
    B=$R/tree-$v/build/compiler
    for mode in fsyntax c; do
        if [ $mode = fsyntax ]; then args=(-fsyntax-only); else args=(-c -o "$O/sqlite-$v.o"); fi
        taskset -c 2 perf stat -x, -e instructions:u,ex_ret_near_ret:u,ex_ret_brn_tkn:u,ls_dispatch.store_dispatch:u "$B" "${args[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c" 2> "$O/$v-$mode.stat"
        taskset -c 2 perf record -q -e ex_ret_near_ret:u -c 1009 -j any_ret,u -o "$O/$v-$mode.data" "$B" "${args[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c" || echo "record failed"
        perf script -i "$O/$v-$mode.data" -F brstack 2> /dev/null | awk '{print $1}' | cut -d/ -f1,2 | sort | uniq -c | sort -rn > "$O/$v-$mode.edges" || true
    done
done
head -3 "$O/base-fsyntax.edges"
echo done

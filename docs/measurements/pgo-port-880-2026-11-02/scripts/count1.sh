#!/usr/bin/env bash
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
for v in base pgo; do
    for mode in -fsyntax-only -E; do
        echo "== $v $mode"
        a=("$mode"); [ "$mode" = -E ] && a=(-E -P -o /dev/null)
        taskset -c 2 perf stat -x, -e instructions:u,ex_ret_near_ret:u,ex_ret_brn:u,ex_ret_brn_tkn:u,ex_ret_brn_misp:u,ls_dispatch.ld_dispatch:u,ls_dispatch.store_dispatch:u "$R/tree-$v/build/compiler" "${a[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c" 2>&1 >/dev/null | cut -d, -f1,3
    done
done

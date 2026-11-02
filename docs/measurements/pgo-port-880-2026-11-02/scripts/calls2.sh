#!/usr/bin/env bash
# calls2.sh VARIANT...: sampled return edges (LBR any_ret) of exp/VARIANT/compiler on sqlite3.c -fsyntax-only,
# symbolized by symbol (callee <- caller).
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
for v in "$@"; do
    B=$R/exp/$v/compiler
    O=$R/exp/$v
    for run in 1 2 3 4; do
        taskset -c 2 perf record -q -e ex_ret_near_ret:u -c $((1009 + run * 2)) -j any_ret,u -o "$O/calls-$run.data" "$B" -fsyntax-only "${BASE[@]}" "$C/sqlite/sqlite3.c"
        perf script -i "$O/calls-$run.data" -F brstack 2> /dev/null | awk '{print $1}' | cut -d/ -f1,2
        rm -f "$O/calls-$run.data"
    done | sort | uniq -c | sort -rn > "$O/calls.edges"
    awk '{split($2,a,"/"); print a[1]; print a[2]}' "$O/calls.edges" | sort -u > "$O/calls.addrs"
    llvm-symbolizer --obj="$B" --functions=linkage --no-demangle < "$O/calls.addrs" | awk 'NR % 3 == 1' > "$O/calls.syms"
    paste -d' ' "$O/calls.addrs" "$O/calls.syms" > "$O/calls.map"
    echo "$v: $(wc -l < "$O/calls.edges") edges"
done

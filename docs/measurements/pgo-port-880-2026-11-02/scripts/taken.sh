#!/usr/bin/env bash
# taken.sh VARIANT: sampled taken branches (LBR) of exp/VARIANT/compiler on sqlite3.c -fsyntax-only, with source lines.
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
v=$1
B=$R/exp/$v/compiler
O=$R/exp/$v
for run in 1 2 3 4; do
    taskset -c 2 perf record -q -e ex_ret_brn_tkn:u -c $((40009 + run * 6)) -j any,u -o "$O/taken-$run.data" "$B" -fsyntax-only "${BASE[@]}" "$C/sqlite/sqlite3.c"
    perf script -i "$O/taken-$run.data" -F brstack 2> /dev/null | tr ' ' '\n' | grep / | cut -d/ -f1,2
    rm -f "$O/taken-$run.data"
done | sort | uniq -c | sort -rn > "$O/taken.edges"
awk '{split($2,a,"/"); print a[1]}' "$O/taken.edges" | sort -u > "$O/taken.addrs"
llvm-symbolizer --obj="$B" --inlines --functions=linkage --no-demangle < "$O/taken.addrs" > "$O/taken.sym"
echo "$v: $(wc -l < "$O/taken.edges") taken edges"

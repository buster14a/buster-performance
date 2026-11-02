#!/usr/bin/env bash
# instructions:u samples of tree-base and tree-pgo's compilers on sqlite3.c (-fsyntax-only, -c), each sample's address
# with its count, and the addresses' inline stacks (llvm-symbolizer).
set -euo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
O=$R/prof2
rm -rf "$O"; mkdir -p "$O"
cd "$O"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
for v in base pgo; do
    B=$R/tree-$v/build/compiler
    for mode in fsyntax c; do
        if [ $mode = fsyntax ]; then args=(-fsyntax-only); else args=(-c -o "$O/sqlite-$v.o"); fi
        taskset -c 2 perf stat -x, -e instructions:u,cycles:u "$B" "${args[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c" 2> "$O/$v-$mode.stat"
        for period in 200003 200009 200017 200023 200029 200033 200041 200063; do
            taskset -c 2 perf record -q -e instructions:u -c $period -o "$O/$v-$mode-$period.data" "$B" "${args[@]}" "${BASE[@]}" "$C/sqlite/sqlite3.c"
            perf script -i "$O/$v-$mode-$period.data" -F ip,dso 2> /dev/null | awk '{print $1, $2}'
            rm -f "$O/$v-$mode-$period.data"
        done | sort | uniq -c > "$O/$v-$mode.ips"
    done
    awk '$3 ~ /compiler/ {print "0x" $2}' "$O/$v-fsyntax.ips" "$O/$v-c.ips" | sort -u > "$O/$v.addresses"
    llvm-symbolizer --obj="$B" --inlines --functions=linkage --no-demangle < "$O/$v.addresses" > "$O/$v.symbolized"
done
cmp "$O/sqlite-base.o" "$O/sqlite-pgo.o" && echo objects-identical
echo done

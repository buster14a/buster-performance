#!/bin/bash
# The record's second hold (#1057): each build's own output of the source benchmarks over sqlite3.c, which time-runs
# doesn't keep (their timed regions, counts, receipts and exit statuses). Run under the 9700X's lock by run-outputs.
set -u
R=$HOME/buster-fast-bench/1057-claude/record; L=$R/logs
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
bench=(--predefines $C/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
for b in 754475d4 4670b2eb; do
    for n in backend-source lowering-source; do
        taskset -c 2 $R/trees/tree-$b/build/compiler benchmark-$n "${bench[@]}" > $L/output-$n-$b.log 2>&1
        echo "benchmark-$n $b status $?" >> $L/receipts.txt
    done
done

#!/bin/bash
# The record's third hold (#1057): benchmark-lowering-source over sqlite3.c again, without --no-default-config, which
# its options' reader refuses (logs/output-lowering-source-*.log: "unknown argument"), as each build's own output and as
# whole processes interleaved by time-runs. Run under the 9700X's lock.
set -u
R=$HOME/buster-fast-bench/1057-claude/record; L=$R/logs
main=$R/trees/tree-754475d4/build/compiler; head=$R/trees/tree-4670b2eb/build/compiler
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
bench=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
for b in 754475d4 4670b2eb; do
    taskset -c 2 $R/trees/tree-$b/build/compiler benchmark-lowering-source "${bench[@]}" > $L/output-lowering-source-2-$b.log 2>&1
    echo "benchmark-lowering-source (again) $b status $?" >> $L/receipts.txt
done
taskset -c 2 $main time-runs --runs 5 --warmups 1 --build main $main --build head $head --list benchmark-lowering-source "${bench[@]}" > $L/lowering-source-2.log 2>&1
echo "lowering-source (again) time-runs status $?" >> $L/receipts.txt

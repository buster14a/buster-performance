#!/usr/bin/env bash
# compile.sh: compile time of sqlite3.c (the frozen corpus, CI's flags) and the compiler's main.c by base's and head's
# -c --tier1, at the default target and at -march=znver5, nine rounds alternating base and head, one lock hold, CPU 2;
# each object's text checked: the default target's identical between base and head.
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
O=out/compile
mkdir -p $O
corpus=$W/corpus
sq="--predefines $corpus/provenance/gnu17-pinned-predefines.txt -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
$CLANG -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $O/predefines.h
mn="-Itree/src -fwrapv -funsigned-char -fno-strict-aliasing --predefines $O/predefines.h tree/src/buster/compiler/main.c"
for name in base head; do
    for march in x86-64 znver5; do
        $W/bin/$name -c --tier1 --tier1-report -march=$march $sq -o $O/sqlite-$name-$march.o > $O/report-sqlite-$name-$march.txt 2>&1
        $W/bin/$name -c --tier1 --tier1-report -march=$march $mn -o $O/main-$name-$march.o > $O/report-main-$name-$march.txt 2>&1
    done
done
for f in sqlite main; do for march in x86-64 znver5; do
    if cmp -s $O/$f-base-$march.o $O/$f-head-$march.o; then echo "$f $march: base and head objects identical"; else echo "$f $march: objects differ"; fi
done; done > $O/objects.txt
size $O/*.o >> $O/objects.txt
$LOCK bash -c "$(declare -f state); state compile >&2
for round in 1 2 3 4 5 6 7 8 9; do for name in base head; do for march in x86-64 znver5; do
    for f in sqlite main; do
        if [ \$f = sqlite ]; then args=\"$sq\"; else args=\"$mn\"; fi
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,task-clock -o $O/perf.txt -- $W/bin/\$name -c --tier1 -march=\$march \$args -o $O/t.o > /dev/null 2>&1
        echo \"\$round \$name \$march \$f cycles \$(grep cycles $O/perf.txt | cut -d, -f1) instructions \$(grep instructions $O/perf.txt | cut -d, -f1) ms \$(grep task-clock $O/perf.txt | cut -d, -f1)\"
    done
done; done; done; state compile-end >&2" > $O/results.txt 2> $O/run.log

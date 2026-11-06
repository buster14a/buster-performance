#!/bin/bash
# main against the lexer head: the objects and diagnostics of sqlite3.c -c, -fsyntax-only and -E, then the counters
# (10 rounds, interleaved) and the head profile of line-crossing loads. CPU 2.
cd ~/buster-fast-bench/1555-claude/run
source ../main/tools/microarch/workloads.sh
SCRATCH=scratch
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
for w in sq-c sq-syn sq-E; do
    for v in main lexer; do
        workload $v $w
        taskset -c 2 "${WL[@]}" > scratch/$v-$w.out 2> scratch/$v-$w.err
        echo "$v $w exit=$?"
    done
    cmp scratch/main-$w.out scratch/lexer-$w.out && cmp scratch/main-$w.err scratch/lexer-$w.err && echo "$w: same output and diagnostics"
done
cmp scratch/main-sq.o scratch/lexer-sq.o && echo "sq-c: same object"
cmp scratch/main-sq.i scratch/lexer-sq.i && echo "sq-E: same preprocessed output"
sha256sum scratch/main-sq.o scratch/lexer-sq.o scratch/main-sq.i scratch/lexer-sq.i bin/compiler-main bin/compiler-lexer
./counters.sh 10 main lexer
./profile.sh lexer ls_misal_loads.ma64:u 997
echo stage3-done

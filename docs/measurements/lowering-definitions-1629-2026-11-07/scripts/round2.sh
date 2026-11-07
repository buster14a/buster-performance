#!/bin/bash
# One round: ROUND, then the trees in this round's order; UNITS the units' trees in this round's order.
cd ~/buster-fast-bench/1629-claude
r=$1; shift 1
for kind in c-testsuite synthetic; do
    if [ "$kind" = c-testsuite ]; then
        files=$(ls cts/tests/single-exec/*.c)
    else
        files=$(ls synthetic/*.c)
    fi
    for t in "$@"; do
        taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds2-$kind/round-$r-$t.txt 2> logs/rounds2-$kind/round-$r-$t.err
        echo "$(date -u +%FT%TZ) $kind round $r $t exit=$? $(grep totals logs/rounds2-$kind/round-$r-$t.txt)" >> logs/progress2.log
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs/units2/objects-$t
        rm -f logs/units2/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs/units2/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units2/runs.txt
    done
done

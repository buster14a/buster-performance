#!/bin/bash
cd ~/buster-fast-bench/1629-claude
r=$1; shift 1
for kind in c-testsuite synthetic; do
    if [ "$kind" = c-testsuite ]; then files=$(ls cts/tests/single-exec/*.c); else files=$(ls synthetic/*.c); fi
    for t in "$@"; do
        for w in cold 1 2 3 4; do
            if [ $w = cold ]; then
                taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds4/$kind-$w-round-$r-$t.txt 2> logs/rounds4/$kind-$w-round-$r-$t.err
            else
                EMIT_AB_OBJECT_WARM=$w taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > logs/rounds4/$kind-$w-round-$r-$t.txt 2> logs/rounds4/$kind-$w-round-$r-$t.err
            fi
            echo "$(date -u +%FT%TZ) $kind $w round $r $t exit=$? $(grep totals logs/rounds4/$kind-$w-round-$r-$t.txt | cut -c1-120)" >> logs/progress4.log
        done
    done
done
files=$(ls cts/tests/single-exec/*.c)
for pass in 1 2; do
    for t in $UNITS; do
        mkdir -p logs/units4/objects-$t
        rm -f logs/units4/objects-$t/*.o
        s=$(date +%s%N)
        (cd logs/units4/objects-$t && taskset -c 2 ../../../trees/$t/build/compiler -c --lanes 1 $(for f in $files; do echo ../../../$f; done) 2> /dev/null)
        st=$?
        e=$(date +%s%N)
        echo "round $r pass $pass tree $t exit=$st ns=$((e - s))" >> logs/units4/runs.txt
    done
done

#!/bin/bash
# One lock hold: 3 interleaved rounds of perf stat of -c sqlite3.c and main.c by both trees, pinned to CPU 2.
cd "$(dirname "$0")" || exit 1
. ./env.sh
out=$M/perf1.tsv
echo -e "round\ttree\tinput\tinstructions\tcycles\tmsec" > $out
for r in 1 2 3; do
    for t in $MAIN $HEAD; do
        for input in sqlite main; do
            if [ $input = sqlite ]; then args=("${SQLITE[@]}"); else args=("${MAINC_ARGS[@]}"); fi
            perf stat -x, -e instructions:u,cycles:u,task-clock -o $M/p1-$r-$t-$input.csv taskset -c 2 $T/$t/build/compiler -o /tmp/1447-seg-$input.o "${args[@]}" > /dev/null 2>&1
            f=$M/p1-$r-$t-$input.csv
            echo -e "$r\t$t\t$input\t$(grep instructions $f | cut -d, -f1)\t$(grep cycles $f | cut -d, -f1)\t$(grep task-clock $f | cut -d, -f1)" >> $out
        done
    done
done

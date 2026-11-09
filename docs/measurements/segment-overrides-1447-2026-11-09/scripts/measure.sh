#!/bin/bash
# perf stat of -c sqlite3.c and main.c by both trees, interleaved, each run under the lock on its own, pinned to CPU 2.
cd "$(dirname "$0")" || exit 1
. ./env.sh
out=$M/perf.tsv
echo -e "round\ttree\tinput\tinstructions\tcycles\tseconds" > $out
for r in 1 2 3 4 5; do
    for t in $MAIN $HEAD; do
        for input in sqlite main; do
            if [ $input = sqlite ]; then args=("${SQLITE[@]}"); else args=("${MAINC_ARGS[@]}"); fi
            $X perf stat -x, -e instructions:u,cycles:u -o $M/perf-$r-$t-$input.csv taskset -c 2 $T/$t/build/compiler -o /tmp/1447-seg-$input.o "${args[@]}" > /dev/null 2>&1
            ins=$(grep instructions $M/perf-$r-$t-$input.csv | cut -d, -f1)
            cyc=$(grep cycles $M/perf-$r-$t-$input.csv | cut -d, -f1)
            sec=$(grep -m1 "seconds time elapsed" $M/perf-$r-$t-$input.csv | awk '{print $1}')
            echo -e "$r\t$t\t$input\t$ins\t$cyc\t$sec" >> $out
        done
    done
done
echo "measure done $(date -Is)"

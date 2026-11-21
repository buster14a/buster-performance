#!/bin/bash
# timing.sh BINARY RUNS FLAGS DIR SHAPE...: for each SHAPE and N in 4000 8000 16000 32000, the median over RUNS runs of
# the check-program stage (ms) of `BINARY -w -c FLAGS --time-stages DIR/SHAPE<N>.c -o /dev/null`.
# #1355's chains: FLAGS=--tier1; #2995's shapes: FLAGS= (empty). On the 9700X, wrap each BINARY run in exclusive.sh.
B=$1; runs=$2; flags=$3; dir=$4; shift 4
for shape in "$@"; do
    for n in 4000 8000 16000 32000; do
        v=""
        for r in $(seq 1 "$runs"); do
            t=$("$B" -w -c $flags --time-stages "$dir/$shape$n.c" -o /dev/null 2>&1 | awk -F'\t' '$1=="time-stage" && $2=="check-program" {print $3}')
            v="$v $t"
        done
        m=$(echo $v | tr ' ' '\n' | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
        echo "$shape $n $m ($v )"
    done
done

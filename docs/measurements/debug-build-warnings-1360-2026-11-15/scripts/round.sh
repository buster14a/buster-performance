#!/bin/bash
# One round inside the hold: every workload by both builds, the order alternating by round and workload.
set -u
round=$1; BASE=$2; HEAD=$3; OUT=$4; shift 4
printf 'round %s: %s\n' "$round" "$(head -1 /var/lib/buster-9700x/owner)" >> $OUT/holds.txt
k=0
for entry in "$@"; do
    name=${entry%%|*}; args=${entry#*|}
    order="base head"; (( (round + k) % 2 )) && order="head base"
    k=$((k + 1))
    for v in $order; do
        X=$BASE/build/compiler; [[ $v == head ]] && X=$HEAD/build/compiler
        obj=$OUT/out/$name-$v.o
        start=$EPOCHREALTIME
        if [[ $name == lua* ]]; then
            perf stat -x, -e instructions:u,cycles:u -o $OUT/out/$name-$v.perf taskset -c 2 ./lua-all.sh "$X" $args > $OUT/out/$name-$v.stdout 2> $OUT/out/$name-$v.stderr
        else
            perf stat -x, -e instructions:u,cycles:u -o $OUT/out/$name-$v.perf taskset -c 2 "$X" $args -o "$obj" --time-stages > $OUT/out/$name-$v.stdout 2> $OUT/out/$name-$v.stderr
        fi
        status=$?
        end=$EPOCHREALTIME
        counters=$(awk -F, '$3=="instructions:u"{i=$1} $3=="cycles:u"{c=$1} END{printf "%s\t%s", i, c}' $OUT/out/$name-$v.perf)
        wall=$(awk -v s=$start -v e=$end 'BEGIN{printf "%.1f", (e - s) * 1000}')
        stages=$(awk '$1=="time-stage"&&$2=="total"{t=$3} $1=="time-stage"&&$2=="check-program"{c=$3} END{printf "%s\t%s", t, c}' $OUT/out/$name-$v.stderr)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$round" "$name" "$v" "$status" "$wall" "$stages" "$counters"
        if [[ $round == 1 ]]; then
            cp $OUT/out/$name-$v.stderr $OUT/out/first-$name-$v.stderr
            if [[ -f $obj ]]; then cp "$obj" $OUT/out/first-$name-$v.o; fi
        fi
    done
done
exit 0

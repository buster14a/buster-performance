#!/bin/bash
# One round inside the hold: every workload by both builds, the order alternating by round and workload.
set -u
round=$1; shift
BASE=$1 HEAD=$2; shift 2
printf 'round %s: %s\n' "$round" "$(head -1 /var/lib/buster-9700x/owner)" >> holds.txt
k=0
for entry in "$@"; do
    name=${entry%%|*}; args=${entry#*|}
    order="base head"; (( (round + k) % 2 )) && order="head base"
    k=$((k + 1))
    for v in $order; do
        [[ $name == sq-debug && $v == base && $round -gt 3 ]] && continue
        X=$BASE/build/compiler; [[ $v == head ]] && X=$HEAD/build/compiler
        obj=out/$name-$v.o
        start=$EPOCHREALTIME
        if [[ $name == lua* ]]; then
            perf stat -x, -e instructions:u,cycles:u -o out/$name-$v.perf taskset -c 2 ./lua-all.sh "$X" $args > out/$name-$v.stdout 2> out/$name-$v.stderr
        else
            perf stat -x, -e instructions:u,cycles:u -o out/$name-$v.perf taskset -c 2 "$X" $args -o "$obj" --time-stages > out/$name-$v.stdout 2> out/$name-$v.stderr
        fi
        status=$?
        end=$EPOCHREALTIME
        counters=$(awk -F, '$3=="instructions:u"{i=$1} $3=="cycles:u"{c=$1} END{printf "%s\t%s", i, c}' out/$name-$v.perf)
        wall=$(awk -v s=$start -v e=$end 'BEGIN{printf "%.1f", (e - s) * 1000}')
        stages=$(awk '$1=="time-stage"&&$2=="total"{t=$3} $1=="time-stage"&&$2=="check-program"{c=$3} END{printf "%s\t%s", t, c}' out/$name-$v.stderr)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$round" "$name" "$v" "$status" "$wall" "$stages" "$counters"
        if [[ $round == 1 ]]; then
            cp out/$name-$v.stderr out/first-$name-$v.stderr
            [[ -f $obj ]] && cp "$obj" out/first-$name-$v.o
        fi
    done
done

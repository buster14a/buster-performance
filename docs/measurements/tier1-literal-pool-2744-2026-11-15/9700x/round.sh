#!/usr/bin/env bash
D=$1; round=$2; shift 2
for input in mid src; do
    target=$D/mid.c; [ $input = src ] && target=$D/head/src
    for program in "$@"; do
        timeout 300 taskset -c 2 "$D/results/$program" "$target" > "$D/results/r$round-$program-$input.log" 2>&1
        echo "$program $input $round status $? $(grep 'c_tokenize ' "$D/results/r$round-$program-$input.log" | tr -s ' ')"
    done
done

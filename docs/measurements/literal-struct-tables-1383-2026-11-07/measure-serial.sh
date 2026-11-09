#!/bin/bash
set -eu
cd "$HOME/buster-fast-bench/1383-struct-codex"
for ((attempt=0;attempt<120;attempt++)); do
    if grep -q "published as build/compiler" final-build.log && grep -q "published as build/compiler" base-build.log; then
        break
    fi
    if grep -qE 'FAILED:|error:' final-build.log base-build.log; then
        echo comparison-build-failed
        exit 2
    fi
    sleep 5
done
grep -q "published as build/compiler" final-build.log
grep -q "published as build/compiler" base-build.log
export EXCLUSIVE_OWNER=codex-1383-struct
export EXCLUSIVE_TITLE="Recover direction 3 of 1383: paired measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
lock="$HOME/buster-fast-bench/exclusive.sh"
test -x measure_struct_tables
test -f file250000.c
test -f local250000.c
test -f flat1000000.c
test -f float50000.c
mkdir -p bin
cp base/build/compiler bin/base
cp final/build/compiler bin/head
printf 'input\trevision\tround\twall_us\tmaxrss_kb\tminor_faults\tmajor_faults\tstatus\n' > results.tsv
for input in file250000.c local250000.c flat1000000.c float50000.c; do
    for round in 0 1 2 3 4 5; do
        if test $((round % 2)) -eq 0; then
            order="base head"
        else
            order="head base"
        fi
        for revision in $order; do
            "$lock" taskset -c 2 ./measure_struct_tables run "./bin/$revision" "$input" "$revision" "$round" >> results.tsv
        done
    done
done
"$lock" taskset -c 2 bash verify_objects.sh
echo measurement-status=0

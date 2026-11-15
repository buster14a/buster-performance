#!/usr/bin/env bash
D=$1; shift
for side in base head base head; do
    timeout 120 taskset -c 2 strace -f -c -o "$D/results/strace-$side.txt" -e trace=clone,clone3,futex,nanosleep,clock_nanosleep,sched_yield,exit_group,munmap,madvise "$D/results/compiler-$side" "$@" > /dev/null 2>&1
    echo "strace $side status $?"
    timeout 120 perf stat -e task-clock,context-switches,cpu-migrations -o "$D/results/perf-$side.txt" taskset -c 2 "$D/results/compiler-$side" "$@" > /dev/null 2>&1
    echo "perf $side status $?"
done

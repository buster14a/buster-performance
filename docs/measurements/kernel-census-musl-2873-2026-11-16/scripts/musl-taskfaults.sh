#!/bin/bash
# musl-taskfaults.sh: each unit compiled a process each on CPU 2, unrecorded, under perf stat counting its own minor
# faults from its exec (inherited by its exit helper): the census"s faults counted, a unit at a time (results/musl/
# taskfaults.csv, one perf stat block a unit, in the loop"s order). In one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source scripts/musl-common.sh
out=results/musl
rm -f "$out/taskfaults.csv"
for f in "${files[@]}"; do
    taskset -c 2 perf stat -x, -e minor-faults,page-faults --append -o "$out/taskfaults.csv" -- "$here/src/build/compiler" "${options[@]}" -c "$f" -o /dev/shm/2873-musl.o > /dev/null 2>&1
done
rm -f /dev/shm/2873-musl.o

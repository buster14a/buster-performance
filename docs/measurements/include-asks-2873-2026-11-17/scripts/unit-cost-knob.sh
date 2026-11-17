#!/bin/bash
# unit-cost-knob.sh OUT: a musl unit's -c by the knob build (job-knob.sh) with its asks never made (BUSTER_ASKS=0) and
# made at a component's third and fifth miss: one executable, one copy; the process's own counters, kernel and user
# (perf stat, 400 runs a setting, on CPU 2; each setting in turn, twice), and the unit's system calls with the asks at
# the third miss (strace: OUT/asks.txt).
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
mkdir -p "$out"
source ../scripts/musl-common.sh
cp knob/build/compiler "$out/knob.compiler"
: > "$out/asks.txt"
for unit in conf/sysconf.c ipc/msgctl.c aio/aio.c aio/aio_suspend.c complex/__cexp.c string/strlen.c; do
    label=$(echo "$unit" | tr '/' '-' | sed 's/\.c$//')
    for turn in 1 2; do
        for asks in 0 3 5; do
            BUSTER_ASKS=$asks taskset -c 2 perf stat -x, -r 400 -e cycles:u,instructions:u,L1-icache-load-misses:u,cycles:k,instructions:k,page-faults -o "$out/$label-asks$asks-$turn.csv" -- "$here/$out/knob.compiler" "${options[@]}" -c "$musl/src/$unit" -o /dev/shm/2873-unit-cost.o > /dev/null 2>&1
        done
    done
    for asks in 0 3 5; do
        BUSTER_ASKS=$asks strace -f -e trace=openat,newfstatat,statx,stat -o "$out/$label-asks$asks.strace" "$here/$out/knob.compiler" "${options[@]}" -c "$musl/src/$unit" -o /dev/shm/2873-unit-cost.o > /dev/null 2>&1
        echo "$label asks at $asks: openat $(grep -c 'openat(' "$out/$label-asks$asks.strace"), failed $(grep 'openat(' "$out/$label-asks$asks.strace" | grep -c ENOENT); stat of a path $(grep -c 'newfstatat(AT_FDCWD' "$out/$label-asks$asks.strace"), of them ENOENT $(grep 'newfstatat(AT_FDCWD' "$out/$label-asks$asks.strace" | grep -c ENOENT)" >> "$out/asks.txt"
    done
done
rm -f "$out"/*.compiler /dev/shm/2873-unit-cost.o
for f in "$out"/*.csv; do
    echo "$(basename "$f" .csv): $(grep -v '^#' "$f" | awk -F, 'NF > 3 {printf "%s=%s ", $3, $1}')"
done > "$out/summary.txt"
cat "$out/asks.txt"

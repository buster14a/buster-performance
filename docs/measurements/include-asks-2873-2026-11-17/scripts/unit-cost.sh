#!/bin/bash
# unit-cost.sh OUT: what a musl unit's -c costs by base2, by scratch (the asks) and by off (the same code, its asks never
# made), for units that make 7, 4, 1 and no asks: the process's own counters (perf stat, 400 runs a compiler, on CPU 2;
# user cycles and instructions, the branches and caches' misses), each compiler in turn, twice.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
mkdir -p "$out"
source ../scripts/musl-common.sh
for name in base2 off scratch; do cp "$name/build/compiler" "$out/$name.compiler"; done
for unit in conf/sysconf.c ipc/msgctl.c aio/aio.c aio/aio_suspend.c complex/__cexp.c; do
    label=$(echo "$unit" | tr '/' '-' | sed 's/\.c$//')
    for turn in 1 2; do
        for name in base2 off scratch; do
            taskset -c 2 perf stat -x, -r 400 -e cycles:u,instructions:u,branch-misses:u,L1-dcache-load-misses:u,L1-icache-load-misses:u,dTLB-load-misses:u,iTLB-load-misses:u,cycles:k -o "$out/$label-$name-$turn.csv" -- "$here/$out/$name.compiler" "${options[@]}" -c "$musl/src/$unit" -o /dev/shm/2873-unit-cost.o > /dev/null 2>&1
        done
    done
done
rm -f "$out"/*.compiler /dev/shm/2873-unit-cost.o
for f in "$out"/*.csv; do
    echo "$(basename "$f" .csv): $(grep -v '^#' "$f" | awk -F, 'NF > 3 {printf "%s=%s ", $3, $1}')"
done > "$out/summary.txt"

#!/bin/bash
# usage: lock.sh ./sweeps.sh ; builds tools/sweeps.c and times the node machine's sweeps over dump.sh's two dumps
# (scratch/sqlite3.dump, scratch/musl.dump), pinned to CPU 2: each unit three times with its own tables, and once
# with the other's. Results in results/sweeps.
set -euo pipefail
cd "$(dirname "$0")"
out=results/sweeps
mkdir -p "$out" build
clang -O3 -march=native -Wall -Wextra -o build/sweeps tools/sweeps.c 2> "$out/sweeps-build.log"
{
    sha256sum tools/sweeps.c build/sweeps scratch/sqlite3.dump scratch/musl.dump
    clang --version | head -1
    echo "cpu: taskset -c 2; governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null || echo unknown)"
} > "$out/sweeps-hashes.txt"
for unit in sqlite3 musl; do
    for run in 1 2 3; do
        taskset -c 2 build/sweeps "scratch/$unit.dump" --passes 31 --ops > "$out/sweeps-$unit-$run.txt"
    done
done
# A unit with the other's tables: what learned tables take of another corpus, and whether what they take is right
# (the tool exits 1 when an emitted entry differs from the stream's).
taskset -c 2 build/sweeps scratch/sqlite3.dump --train scratch/musl.dump --passes 5 > "$out/sweeps-sqlite3-by-musl.txt" || echo "sqlite3 by musl: exit $?" >> "$out/sweeps-hashes.txt"
taskset -c 2 build/sweeps scratch/musl.dump --train scratch/sqlite3.dump --passes 5 > "$out/sweeps-musl-by-sqlite3.txt" || echo "musl by sqlite3: exit $?" >> "$out/sweeps-hashes.txt"
echo done > "$out/sweeps.done"

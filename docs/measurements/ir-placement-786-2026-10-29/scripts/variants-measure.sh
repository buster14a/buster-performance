#!/bin/bash
# Each variant's benchmark-ir paths at fixed work (--passes 1, one path; the repetitions they print must match between
# variants), under perf stat, three rounds with the variants' order turning, pinned to the first CPU this process may run on.
root=$HOME/.cache/claude-786/o3
out=$root/out
mkdir -p "$out"
variants=(v0 v1 v2 v3 v4)
cpu="$(awk '/^Cpus_allowed_list:/ { split($2, cpus, /[,-]/); print cpus[1] }' /proc/self/status)"
echo "cpu $cpu"
for round in 1 2 3; do
    for k in 0 1 2 3 4; do
        v=${variants[$(( (k + round) % 5 ))]}
        for path in vector scalar uses cfg; do
            perf stat -x, -e instructions:u,cycles:u -o "$out/$v-$path-$round.csv" -- taskset -c "$cpu" "$root/$v/compiler" benchmark-ir --only $path --passes 1 > "$out/$v-$path-$round.log" 2>&1
        done
        taskset -c "$cpu" "$root/$v/compiler" benchmark-ir-optimize > "$out/$v-optimize-$round.log" 2>&1
    done
done
echo measured

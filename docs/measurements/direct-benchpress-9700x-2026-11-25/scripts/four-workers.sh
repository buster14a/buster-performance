#!/bin/bash
set -eu

# Invoke through a symlink named after the compiler executable with -four appended.
compiler=${0%-four}
output=$2
shift 2
pids=()
for cpu in 0 1 2 3; do
    taskset -c "$cpu" "$compiler" -o "$output.$cpu" "$@" &
    pids+=("$!")
done
for pid in "${pids[@]}"; do
    wait "$pid"
done

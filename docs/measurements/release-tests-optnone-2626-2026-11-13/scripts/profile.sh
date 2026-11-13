#!/bin/bash
# perf's samples of one listed benchmark by the base's and the head's executables (placement 0), inside the lock:
# profile.sh NAME. Writes results/profile/NAME.{base,head}.txt: each symbol's share of user cycles, and the
# instructions per symbol.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2626-claude
name=$1
line=$(awk -F'\t' -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
mkdir -p "$d/results/profile" "$d/scratch/profile"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for side in base head; do
    data=$d/scratch/profile/$name.$side.data
    taskset -c "$cpus" perf record -q -e cycles:u -c 200003 -o "$data" -- "$d/placements/$side/compiler-0" "${argv[@]}" > /dev/null 2>&1
    perf report -q -i "$data" --no-children --sort symbol --percent-limit 0.3 --stdio 2> /dev/null | head -60 > "$d/results/profile/$name.$side.txt"
    taskset -c "$cpus" perf stat -x, -e cycles:u,instructions:u -- "$d/placements/$side/compiler-0" "${argv[@]}" 2>&1 > /dev/null | tail -2 >> "$d/results/profile/$name.$side.txt"
done

#!/bin/bash
# annotate.sh NAME SYMBOL CANDIDATE: cycles:u samples of one listed benchmark by the base and CANDIDATE (placement 0),
# inside the lock, and perf annotate of SYMBOL: results/annotate/NAME.{base,CANDIDATE}.txt (hottest lines first).
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-step5b-claude
name=$1; symbol=$2; candidate=$3
line=$(awk -F"\t" -v n="$name" "\$1 == n" "$d/inputs/benchmarks.txt")
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
mkdir -p "$d/results/annotate" "$d/scratch/annotate"
cd "$d/base" || exit 2
for side in base "$candidate"; do
    data=$d/scratch/annotate/$name.$side.data
    taskset -c "$cpus" perf record -q -e cycles:u -c 20011 -o "$data" -- "$d/placements/$side/compiler-0" "${argv[@]}" > /dev/null 2>&1
    perf annotate -q -i "$data" --stdio -s "$symbol" 2> /dev/null > "$d/results/annotate/$name.$side.txt"
done

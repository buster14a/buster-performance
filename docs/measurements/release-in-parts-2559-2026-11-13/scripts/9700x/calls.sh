#!/bin/bash
# The calls a listed benchmark makes, by sampled branch stacks (perf record -j any_call,u), for the base's and the
# candidates' executables (placement 0), inside the lock: calls.sh NAME CANDIDATE... Writes
# results/calls/NAME.SIDE.txt: the call pairs (caller -> callee) by their share of the sampled calls.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
name=$1; shift
line=$(awk -F'\t' -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
mkdir -p "$d/results/calls" "$d/scratch/calls"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for side in base "$@"; do
    data=$d/scratch/calls/$name.$side.data
    taskset -c "$cpus" perf record -q -j any_call,u -e cycles:u -c 500009 -o "$data" -- "$d/placements/$side/compiler-0" "${argv[@]}" > /dev/null 2>&1
    perf report -q -i "$data" -b --sort symbol_from,symbol_to --percent-limit 0.4 --stdio 2> /dev/null | head -70 > "$d/results/calls/$name.$side.txt"
done

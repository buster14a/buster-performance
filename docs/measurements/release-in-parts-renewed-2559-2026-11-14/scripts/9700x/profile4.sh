#!/bin/bash
# User EVENT samples (cycles:u by default) by symbol of one listed benchmark, by the base and by CANDIDATE (placement
# 0), inside the lock: profile4.sh NAME CANDIDATE. perf samples every 200,003 events; results/profile/NAME.{base,
# CANDIDATE}.${EVENT_TAG:-cyc}.all.txt list every symbol's samples, the most first (profile3.sh cut its listing, sorted by
# name, at 400 lines, which dropped a larger executable's later names).
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-step5b-claude
name=$1; candidate=$2
line=$(awk -F"\t" -v n="$name" "\$1 == n" "$d/inputs/benchmarks.txt")
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
mkdir -p "$d/results/profile" "$d/scratch/profile"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for side in ${BASE:-base} "$candidate" ${PROFILE_ALSO:-}; do
    data=$d/scratch/profile/$name.$side.${EVENT_TAG:-cyc}.data
    taskset -c "$cpus" perf record -q -e ${EVENT:-cycles:u} -c 200003 -o "$data" -- "$d/placements/$side/compiler-0" "${argv[@]}" > /dev/null 2>&1
    perf report -q -i "$data" --no-children --sort symbol -F sample,sym --stdio 2> /dev/null | sort -rn > "$d/results/profile/$name.$side.${EVENT_TAG:-cyc}.all.txt"
done

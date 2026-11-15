#!/bin/bash
# User instructions by symbol of one listed benchmark, by the base and by CANDIDATE (placement 0), inside the lock:
# profile2.sh NAME CANDIDATE. perf samples instructions:u every 100,003, so a symbol's samples are its instructions over
# that; results/profile/NAME.{base,CANDIDATE}.ins.txt list samples and symbol.
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
    data=$d/scratch/profile/$name.$side.ins.data
    taskset -c "$cpus" perf record -q -e instructions:u -c 100003 -o "$data" -- "$d/placements/$side/compiler-0" "${argv[@]}" > /dev/null 2>&1
    perf report -q -i "$data" --no-children --sort symbol -F sample,sym --stdio 2> /dev/null | head -400 > "$d/results/profile/$name.$side.ins.txt"
done

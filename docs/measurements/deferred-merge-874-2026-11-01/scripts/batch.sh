#!/bin/bash
# One lock hold's jobs: FIRST to FIRST + COUNT - 1 of JOBS in ROUND's order, rotated by 7. Arguments: LOG ROUND JOBS FIRST COUNT.
. ~/buster-fast-bench/874-verify/scripts/env.sh
L="$1"
round="$2"
jobs="$3"
first="$4"
count="$5"
mapfile -t lines < "$jobs"
total=${#lines[@]}
for ((i = first; i < first + count && i < total; i += 1)); do
    read -r -a job <<< "${lines[$(((i + (round - 1) * 7) % total))]}"
    unit="${job[0]}"
    passes="${job[1]}"
    runs=("${job[@]:2}")
    n=${#runs[@]}
    ordered=()
    for ((k = 0; k < n; k += 1)); do
        ordered+=("${runs[$(((k + round) % n))]}")
    done
    "$D/scripts/runs.sh" "$L" "$round" "$unit" "$passes" "${ordered[@]}"
done

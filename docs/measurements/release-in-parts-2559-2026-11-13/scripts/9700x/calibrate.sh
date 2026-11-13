#!/bin/bash
# One run of each listed benchmark (inputs/benchmarks.txt, or the names given) by the base build, inside the lock: its
# wall time and status, for the A/B's sizes. calibrate.sh [NAME...]
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
mkdir -p "$d/scratch/bench" "$d/results"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
while IFS=$'\t' read -r name cpus arguments; do
    if [ "$#" -ne 0 ]; then
        case " $* " in *" $name "*) ;; *) continue ;; esac
    fi
    read -r -a argv <<< "$arguments"
    start=$EPOCHREALTIME
    taskset -c "$cpus" "$d/placements/base/compiler-0" "${argv[@]}" > "$d/logs/calibrate-$name.log" 2>&1
    status=$?
    end=$EPOCHREALTIME
    printf '%s\t%s\t%s s\tstatus %s\n' "$name" "$cpus" "$(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.2f", b - a }')" "$status" >> "$d/results/calibrate.txt"
done < "$d/inputs/benchmarks.txt"

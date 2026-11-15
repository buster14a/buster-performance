#!/bin/bash
# padbench.sh NAME RUNS: one time-runs comparison of a listed benchmark inside the lock (lock.sh) over the base's and
# a candidate's executables with main.c padded by 0, 16, 32 and 48 bytes (build-pad.sh: sub-line placements), which
# tells a difference in the code from one in where it sits within its 64-byte lines. PADS names the builds
# (placements/NAME-pad; "p ph4" by default). The report goes to results/pad/NAME.TIME.txt; padsummary.sh reads it.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-step5b-claude
name=$1; runs=$2
line=$(awk -F'\t' -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
[ -n "$line" ] || { echo "no benchmark $name" >&2; exit 2; }
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
builds=()
for b in ${PADS:-p ph4}; do
    for s in 0 16 32 48; do
        builds+=(--build "$b-$s" "$d/placements/$b-pad/compiler-$s")
    done
done
mkdir -p "$d/results/pad" "$d/scratch/copies"
out=$d/results/pad/$name.$(date -u +%Y%m%dT%H%M%S).txt
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
start=$EPOCHREALTIME
taskset -c "$cpus" "$d/placements/base/compiler-0" time-runs --runs "$runs" --directory "$d/scratch/copies" "${builds[@]}" --list "${argv[@]}" > "$out" 2>&1
status=$?
printf 'status %s, %s s in the hold, pads %s, runs %s\n' "$status" "$(awk -v a="$start" -v b="$EPOCHREALTIME" 'BEGIN { printf "%.1f", b - a }')" "${PADS:-p ph4}" "$runs" >> "$out"
exit $status

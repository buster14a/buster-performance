#!/bin/bash
# One time-runs comparison of a listed benchmark inside the lock (lock.sh), as the 9700X job compares a pull request
# with its base (#1050, #509): bench.sh NAME RUNS [PLACEMENT...]
# The builds are base, head and base-again (the base's executables a second time, the comparison's floor), each at the
# PLACEMENTs given (main.c's code moved by that many bytes; all four by default), each executable from a fresh copy, in
# each run's order of a Williams design, after one warm-up each, pinned to the benchmark's CPUs (inputs/benchmarks.txt).
# The report goes to results/bench/NAME.TIME.txt.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-step5b-claude
name=$1; runs=$2; shift 2
candidate=${CANDIDATE:-head}
placements=${*:-0 1088 2112 3136}
line=$(awk -F'\t' -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
[ -n "$line" ] || { echo "no benchmark $name" >&2; exit 2; }
IFS=$'\t' read -r _ cpus arguments <<< "$line"
read -r -a argv <<< "$arguments"
builds=()
base=${BASE:-base}
for b in "base:$base" "$candidate:$candidate" "base-again:$base"; do
    for s in $placements; do
        builds+=(--build "${b%%:*}" "$d/placements/${b#*:}/compiler-$s")
    done
done
mkdir -p "$d/results/bench" "$d/scratch/bench" "$d/scratch/copies"
out=$d/results/bench/$name.$(date -u +%Y%m%dT%H%M%S)${CANDIDATE:+.$CANDIDATE}.txt
head -1 /var/lib/buster-9700x/owner > "$out.holder"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
start=$EPOCHREALTIME
taskset -c "$cpus" "$d/placements/${BASE:-base}/compiler-0" time-runs --runs "$runs" --directory "$d/scratch/copies" "${builds[@]}" --list "${argv[@]}" > "$out" 2>&1
status=$?
printf 'status %s, %s s in the hold, placements %s, runs %s\n' "$status" "$(awk -v a="$start" -v b="$EPOCHREALTIME" 'BEGIN { printf "%.1f", b - a }')" "$placements" "$runs" >> "$out"
exit $status

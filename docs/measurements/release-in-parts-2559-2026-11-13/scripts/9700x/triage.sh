#!/bin/bash
# One process of each named benchmark by the base's and by a candidate's executable (placement 0), inside the lock:
# its user instructions and cycles (perf stat), which tell a change in the code from one in its placement.
# triage.sh CANDIDATE NAME... ; CANDIDATE names placements/CANDIDATE/compiler-0. Lines go to results/triage-CANDIDATE.txt:
# NAME, base and candidate instructions, their ratio, base and candidate cycles, their ratio.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
candidate=$1; shift
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
count() { taskset -c "$1" perf stat -x, -e instructions:u,cycles:u -- "${@:2}" 2>&1 > /dev/null | awk -F, '/instructions:u/ { i = $1 } /cycles:u/ { c = $1 } END { print i, c }'; }
for name in "$@"; do
    line=$(awk -F'\t' -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
    IFS=$'\t' read -r _ cpus arguments <<< "$line"
    read -r -a argv <<< "$arguments"
    read -r bi bc <<< "$(count "$cpus" "$d/placements/base/compiler-0" "${argv[@]}")"
    read -r hi hc <<< "$(count "$cpus" "$d/placements/$candidate/compiler-0" "${argv[@]}")"
    awk -v n="$name" -v bi="$bi" -v hi="$hi" -v bc="$bc" -v hc="$hc" 'BEGIN { printf "%-28s %14s %14s %+7.2f%% %14s %14s %+7.2f%%\n", n, bi, hi, 100 * (hi / bi - 1), bc, hc, 100 * (hc / bc - 1) }' >> "$d/results/triage-$candidate.txt"
done

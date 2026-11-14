#!/usr/bin/env bash
# #2624, Develop's run time, further sides: each SIDE in SIDES is the base tree with $d/SIDE.patch applied, built as
# ./build.sh builds it (Develop, CI's toolchain, BUSTER_HOST_ARCH=znver5) with its clean build's time kept; then ROUNDS
# rounds of round.sh over base, the SIDES and release, each one hold of the 9700X's lock, the order rotating.
set -euo pipefail
d=~/buster-fast-bench/2624-claude
export EXCLUSIVE_OWNER=claude-2624 EXCLUSIVE_TITLE="Develop's run time (#2624)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2624
export BUSTER_HOST_ARCH=znver5 LC_ALL=C
lock=~/buster-fast-bench/exclusive.sh
read -r -a extra <<< "${SIDES:?}"
for side in "${extra[@]}"; do
    if [ ! -x "$d/compiler-$side" ]; then
        rm -rf "$d/$side"
        mkdir "$d/$side"
        (cd "$d/base" && tar -c --exclude=./build .) | tar -x -C "$d/$side"
        (cd "$d/$side" && patch -p1 -s < "$d/$side.patch")
        "$lock" bash -c "cd '$d/$side' && ./build.sh > '$d/build-$side.log' 2>&1 && cp build/compiler '$d/compiler-$side'"
    fi
done
out=$d/results-${SIDES// /-}.tsv
: > "$out"
sides=(base "${extra[@]}" release)
n=${#sides[@]}
for round in $(seq 1 "${ROUNDS:-11}"); do
    r=$(( (round - 1) % n ))
    order=("${sides[@]:r}" "${sides[@]:0:r}")
    RESULTS="$out" "$lock" "$d/round.sh" "$round" "${order[@]}"
done
echo done >> "$out"

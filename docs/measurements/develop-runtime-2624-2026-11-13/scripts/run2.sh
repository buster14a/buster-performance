#!/usr/bin/env bash
# #2624, Develop's run time: Develop at the base (0a55fb99), Develop with k5's splitter (buster-performance's
# release-in-parts-2559 k5: local copies for read statics, readable tables' strings, --keep-statics on), and Release at
# the base, all built as ./build.sh builds them (CI's toolchain) at BUSTER_HOST_ARCH=znver5; then ROUNDS rounds of
# round.sh, each one hold of the 9700X's lock, the sides' order rotating.
set -euo pipefail
d=~/buster-fast-bench/2624-claude
export EXCLUSIVE_OWNER=claude-2624 EXCLUSIVE_TITLE="Develop's run time (#2624)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2624
export BUSTER_HOST_ARCH=znver5 LC_ALL=C
lock=~/buster-fast-bench/exclusive.sh
if [ ! -x "$d/compiler-k5d" ]; then
    rm -rf "$d/k5d"
    cp -a "$d/base" "$d/k5d"
    rm -rf "$d/k5d/build"
    (cd "$d/k5d" && patch -p1 -s < "$d/k5d.patch")
    "$lock" bash -c "cd '$d/k5d' && ./build.sh > '$d/build-k5d.log' 2>&1 && cp build/compiler '$d/compiler-k5d'"
fi
if [ ! -x "$d/compiler-release" ]; then
    "$lock" bash -c "cd '$d/base' && ./build.sh --config Release > '$d/build-release.log' 2>&1 && cp build/cmake/*/Release/compiler '$d/compiler-release'"
fi
: > "$d/results2.tsv"
sides=(base k5d release)
for round in $(seq 1 "${ROUNDS:-11}"); do
    r=$(( (round - 1) % 3 ))
    order=("${sides[@]:r}" "${sides[@]:0:r}")
    RESULTS="$d/results2.tsv" "$lock" "$d/round.sh" "$round" "${order[@]}"
done
echo done >> "$d/results2.tsv"

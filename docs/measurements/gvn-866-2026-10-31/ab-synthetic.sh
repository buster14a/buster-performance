#!/bin/bash
# #866's synthetic whole-pass A/B on the 9700X. Each process takes the shared host lock for one benchmark run, and is
# pinned to CPU 2. ROOT holds `cand` and `basegvn`: the PR's pass, and main's pass behind the PR's measurement-only
# benchmark adapter. Run this script on benchpress from any directory.
set -e
ROOT=${ROOT:-$HOME/gvn946}
for run in 1 2 3; do
    if [ $((run % 2)) -eq 1 ]; then order=(basegvn cand); else order=(cand basegvn); fi
    for tree in "${order[@]}"; do
        for place in default 256 1024; do
            if [ "$place" = default ]; then exe="$ROOT/$tree/build/compiler"; else exe="$ROOT/$tree/shifted/compiler-$place"; fi
            echo "### run=$run tree=$tree place=$place"
            EXCLUSIVE_OWNER=opencode-gvn946 \
            EXCLUSIVE_TITLE="GVN 946 final $run $tree $place" \
            EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/946" \
                "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "$exe" \
                benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21
        done
    done
done

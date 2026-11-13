#!/usr/bin/env bash
# #2624, finding 1 for Develop: Develop's executable at the base (0a55fb99) and with presplit's readable strings (the
# head), built as ./build.sh builds by default (Develop, CI's toolchain), at BUSTER_HOST_ARCH=znver5; then ROUNDS rounds
# of round.sh, each one hold of the 9700X's lock, alternating which side runs first.
set -euo pipefail
d=~/buster-fast-bench/2624-claude
export EXCLUSIVE_OWNER=claude-2624 EXCLUSIVE_TITLE="Develop's readable strings (#2624)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2624
export BUSTER_HOST_ARCH=znver5 LC_ALL=C
lock=~/buster-fast-bench/exclusive.sh
for side in base head; do
    if [ ! -x "$d/compiler-$side" ]; then
        "$lock" bash -c "cd '$d/$side' && ./build.sh > '$d/build-$side.log' 2>&1 && cp build/compiler '$d/compiler-$side'"
    fi
done
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$d/predefines.h"
: > "$d/results.tsv"
for round in $(seq 1 "${ROUNDS:-11}"); do
    if [ $((round % 2)) = 1 ]; then order="base head"; else order="head base"; fi
    "$lock" "$d/round.sh" "$round" $order
done
echo done >> "$d/results.tsv"

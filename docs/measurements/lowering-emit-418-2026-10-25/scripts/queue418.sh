#!/bin/bash
# PR #418's review: main (5863eeda) against the PR head (56243f75) on the -c path after checking, one shared harness.
D=~/buster-fast-bench/ab418-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-418-emit-ab
export EXCLUSIVE_TITLE="PR #418 review: paired main-vs-PR -c emission on c-testsuite"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/418"
L="$D/log.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
for t in main pr; do
    (cd "$D/$t" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> "$L" 2>&1
    echo "build $t exit=$? $(date -Is)" >> "$L"
done
for round in 1 2 3 4 5; do
    if [ $((round % 2)) -eq 1 ]; then order="main pr"; else order="pr main"; fi
    for t in $order; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 "$D/$t/build/compiler" benchmark-emit-ab --passes 21 "$D"/single-exec/*.c > "$D/round-$round-$t.txt" 2>&1
        echo "round $round $t exit=$? $(grep totals "$D/round-$round-$t.txt") $(date -Is)" >> "$L"
        sleep 20
    done
done
echo done >> "$L"

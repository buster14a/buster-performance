#!/bin/bash
# PR #418's review, second round: main, the PR head and the head with the made-name table only where names are made.
D=~/buster-fast-bench/ab418-claude
cd "$D" || exit 1
while ! grep -qx done "$D/log.txt"; do sleep 30; done
export EXCLUSIVE_OWNER=claude-418-emit-ab
export EXCLUSIVE_TITLE="PR #418 review: paired main-vs-PR -c emission on c-testsuite"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/418"
L="$D/log-b.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
(cd "$D/fast" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> "$L" 2>&1
echo "build fast exit=$? $(date -Is)" >> "$L"
for round in 1 2 3 4 5 6; do
    case $((round % 3)) in
        1) order="main pr fast" ;;
        2) order="pr fast main" ;;
        0) order="fast main pr" ;;
    esac
    for t in $order; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 "$D/$t/build/compiler" benchmark-emit-ab --passes 21 "$D"/single-exec/*.c > "$D/b-round-$round-$t.txt" 2>&1
        echo "round $round $t exit=$? $(grep totals "$D/b-round-$round-$t.txt") $(date -Is)" >> "$L"
        sleep 20
    done
done
echo done >> "$L"

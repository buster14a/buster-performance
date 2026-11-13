#!/bin/bash
# After the triage: the tests' run time (two rounds, the sides alternating) and the build's times (two rounds), each
# step its own hold.
set -u
d=$HOME/buster-fast-bench/2626-claude
L=$d/scripts/lock.sh
until grep -q '^triage-done' "$d/results/triage-head.txt" 2>/dev/null; do sleep 30; done
for side in base head; do
    [ -d "$d/$side-g" ] || { mkdir "$d/$side-g"; (cd "$d/$side" && tar -c --exclude=./build .) | tar -x -C "$d/$side-g"; }
done
: > "$d/results/buildtimes.tsv"
for round in 1 2; do
    if [ "$round" = 1 ]; then order="base head"; else order="head base"; fi
    for side in $order; do "$L" "$d/scripts/tests.sh" "$side" "$round"; done
    for side in $order; do
        for case in clean backend frontend; do "$L" "$d/scripts/buildtimes.sh" "$side" "$round" "$case"; done
    done
done
echo done >> "$d/results/buildtimes.tsv"

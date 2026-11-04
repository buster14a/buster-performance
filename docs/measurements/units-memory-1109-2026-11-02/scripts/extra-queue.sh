#!/bin/bash
# extra-queue.sh: after head-queue.sh, three more interleaved rounds of build.sh's 42 sources with -c by main (a4a2182a)
# and the head (08cf75ce) by default, into units3.tsv, each run its own hold of the lock: run 5's first rounds of the two
# differed by more than the head's difference from main.
dir=~/buster-fast-bench/1109-claude
until grep -q "queue done" "$dir/link2.tsv" 2> /dev/null; do sleep 30; done
lock() { EXCLUSIVE_OWNER=claude-1109 EXCLUSIVE_TITLE="Problem 1109: $1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1165 ~/buster-fast-bench/exclusive.sh "${@:2}" >> "$dir/extra-queue.log" 2>&1; }
for round in 3 4 5; do
    lock "-c main default round $round" "$dir/units-run.sh" "$dir/a4a2182a" "$dir/units3.tsv" main-default
    lock "-c head default round $round" "$dir/units-run.sh" "$dir/08cf75ce" "$dir/units3.tsv" head-default
done
echo "queue done" >> "$dir/units3.tsv"

#!/bin/bash
# units-queue.sh OUT: two rounds of build.sh's 41 sources at once with -c: main (3ce71ec3) and the head (282c4494) by
# default, and the head with 12 GiB and 6 GiB for the units' estimates; each run its own hold of the lock.
out=$1
dir=~/buster-fast-bench/1109-claude
for round in 1 2; do
    for config in "3ce71ec3 base-default" "282c4494 head-default" "282c4494 head-12g --units-memory=12884901888" "282c4494 head-6g --units-memory=6442450944"; do
        set -- $config
        tree=$1; label=$2; shift 2
        EXCLUSIVE_OWNER=claude-1109 EXCLUSIVE_TITLE="Problem 1109: units $label round $round" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1109 \
            ~/buster-fast-bench/exclusive.sh "$dir/units-run.sh" "$dir/$tree" "$out" "$label" "$@" >> "$dir/queue.log" 2>&1
    done
done
echo "queue done" >> "$out"

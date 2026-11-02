#!/bin/bash
# after-queue.sh PID: once PID ends, the huge-pages round on the head (282c4494) into thp2.tsv, in one hold of the lock.
while kill -0 "$1" 2> /dev/null; do sleep 5; done
dir=~/buster-fast-bench/1109-claude
EXCLUSIVE_OWNER=claude-1109 EXCLUSIVE_TITLE="Problem 1109: huge pages A/B on 282c4494" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1109 \
    ~/buster-fast-bench/exclusive.sh "$dir/thp-round.sh" "$dir/282c4494" "$dir/thp2.tsv" >> "$dir/after-queue.log" 2>&1
echo "after done" >> "$dir/thp2.tsv"

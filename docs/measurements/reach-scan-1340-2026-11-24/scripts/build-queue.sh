#!/bin/bash
# The three builds, one hold each, one after another.
cd ~/buster-fast-bench/1340-reach
for tree in base head stage1; do
    EXCLUSIVE_OWNER=1340-reach-claude EXCLUSIVE_TITLE="#1340 part 1: the reach scan" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
        ~/buster-fast-bench/exclusive.sh timeout -k 5 1500 ./build-one.sh $tree
    echo "$tree exit=$?"
done
echo builds-done

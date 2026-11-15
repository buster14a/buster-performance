#!/bin/bash
# queue-f.sh: clean builds of the branch (TREE=split) and main (src) alternating, two
# of each per sanitizer, a lock hold each.
cd ~/buster-fast-bench/2639-claude
# (no wait: the split A/B runs after these builds, with the branch tree's splitter)
for s in memory address thread; do
    TREE=split ./build-clean2.sh branch-$s $s
    ./build-clean2.sh main2-$s $s
    TREE=split ./build-clean2.sh branch2-$s $s
done
echo finished > results/queue-f.done

#!/bin/bash
# queue-i.sh: the branch's head with the refit cost (TREE=split): clean builds, ASan and MSan twice, TSan once, then the
# MSan executable against main's (identity.sh), a lock hold each.
cd ~/buster-fast-bench/2639-claude
for round in 1 2; do
    for s in address memory thread; do
        [ $round = 2 ] && [ $s = thread ] && continue
        TREE=split ./build-clean2.sh branch3-$round-$s $s
    done
done
./identity.sh identity3-memory memory
echo finished > results/queue-i.done

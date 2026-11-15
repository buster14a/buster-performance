#!/bin/bash
# queue-a.sh: main's clean native sanitizer builds, a lock hold each.
cd ~/buster-fast-bench/2639-claude
for s in memory address thread; do
    ./build-clean2.sh main-$s $s
done
echo finished > results/queue-a.done

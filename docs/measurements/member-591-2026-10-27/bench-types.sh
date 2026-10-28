#!/bin/bash
# bench-types.sh TREE: benchmark-types' lookups on CPU 2 under the lock, twice, into TREE/bench-types.txt.
cd ~/buster-fast-bench/member-591-claude/"$1" || exit 1
~/buster-fast-bench/member-591-claude/lock.sh bash -c 'for i in 1 2; do taskset -c 2 ./build/compiler benchmark-types --only lookups; done' > bench-types.txt 2>&1

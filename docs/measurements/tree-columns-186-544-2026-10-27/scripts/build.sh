#!/bin/bash
# build.sh TREE: builds TREE's compiler under the lock, without -g (as the 9700X job builds).
set -e
cd ~/buster-fast-bench/tree-186-544-claude/"$1"
BUSTER_DEBUG_INFO=0 ../lock.sh ./build.sh > build.log 2>&1
tail -2 build.log

#!/bin/bash
# build.sh TREE [debug]: builds TREE's compiler under the lock (with -g when debug is given).
set -e
cd ~/buster-fast-bench/check-input-529b/"$1"
if [ "$2" = debug ]; then
    ../lock.sh ./build.sh > build.log 2>&1
else
    BUSTER_DEBUG_INFO=0 ../lock.sh ./build.sh > build.log 2>&1
fi
tail -3 build.log

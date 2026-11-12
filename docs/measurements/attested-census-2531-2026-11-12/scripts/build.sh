#!/bin/bash
# build.sh: the census tree, built under the lock, without debug information (the disk is nearly full).
cd "$(dirname "$0")/src" || exit 1
BUSTER_DEBUG_INFO=0 ./build.sh > ../build.log 2>&1
echo "status $?" >> ../build.log

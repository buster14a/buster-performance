#!/bin/bash
# build.sh TREE: TREE built in Release without debug information, under the caller's lock.
cd "$(dirname "$0")/$1" || exit 1
BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../build-$1.log 2>&1
echo "status $?" >> ../build-$1.log
tail -2 ../build-$1.log

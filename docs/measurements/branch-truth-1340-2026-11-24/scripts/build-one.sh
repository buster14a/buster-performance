#!/bin/bash
# Builds one tree as the 9700X job builds it and copies its compiler to bin/compiler-NAME. Usage: build-one.sh NAME
set -u
name=$1
cd ~/buster-fast-bench/1340-truth/$name || exit 1
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../results/build-$name.log 2>&1
echo "build-status=$? seconds=$(( $(date +%s) - start )) commit=$(git rev-parse HEAD) dirty=$(git status --porcelain | wc -l)" >> ../results/build-$name.log
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" ../bin/compiler-$name && chmod +x ../bin/compiler-$name
tail -1 ../results/build-$name.log

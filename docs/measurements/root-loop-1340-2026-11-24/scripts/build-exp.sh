#!/bin/bash
# Builds the head tree with a throwaway patch (bin/PATCH, not for merge) as the 9700X job builds it, copies its compiler
# to bin/compiler-NAME and takes the patch off again. One hold. Usage: build-exp.sh PATCH NAME
set -u
cd ~/buster-fast-bench/1340-roots/head || exit 1
out=~/buster-fast-bench/1340-roots/results
git apply ../bin/"$1" || { echo "patch failed" > "$out/build-$2.failed"; exit 1; }
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build-$2.log" 2>&1
echo "build-status=$? seconds=$(( $(date +%s) - start )) commit=$(git rev-parse HEAD)" >> "$out/build-$2.log"
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" ~/buster-fast-bench/1340-roots/bin/compiler-"$2" && chmod +x ~/buster-fast-bench/1340-roots/bin/compiler-"$2"
git apply -R ../bin/"$1"
echo done > "$out/build-$2.complete"

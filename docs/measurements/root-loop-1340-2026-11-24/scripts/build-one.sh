#!/bin/bash
# Builds one tree of ~/buster-fast-bench/1340-roots as the 9700X job builds it and copies its compiler to bin/. One hold.
set -u
name=$1
cd ~/buster-fast-bench/1340-roots/"$name" || exit 1
out=~/buster-fast-bench/1340-roots/results
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build-$name.log" 2>&1
echo "build-status=$? seconds=$(( $(date +%s) - start )) commit=$(git rev-parse HEAD)" >> "$out/build-$name.log"
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" ~/buster-fast-bench/1340-roots/bin/compiler-"$name" && chmod +x ~/buster-fast-bench/1340-roots/bin/compiler-"$name"
echo done > "$out/build-$name.complete"

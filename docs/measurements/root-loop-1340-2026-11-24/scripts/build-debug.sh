#!/bin/bash
# Builds one tree of ~/buster-fast-bench/1340-roots as the 9700X job builds it but with debug information (for perf's
# source lines only: no timing is taken from it) and copies its compiler to bin/compiler-NAME-g. One hold.
set -u
name=$1
cd ~/buster-fast-bench/1340-roots/"$name" || exit 1
out=~/buster-fast-bench/1340-roots/results
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > "$out/build-$name-g.log" 2>&1
echo "build-status=$? seconds=$(( $(date +%s) - start )) commit=$(git rev-parse HEAD)" >> "$out/build-$name-g.log"
cp "$(BUSTER_HOST_ARCH=znver5 ./build.sh print-output --config Release 2>/dev/null)" ~/buster-fast-bench/1340-roots/bin/compiler-"$name"-g && chmod +x ~/buster-fast-bench/1340-roots/bin/compiler-"$name"-g
echo done > "$out/build-$name-g.complete"

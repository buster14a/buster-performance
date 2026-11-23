#!/bin/bash
# job-dp4.sh: the default path's branch with main 94ec1ca8c merged in (b43c55d58): built whole, the driver's eight parts,
# main.c compiled by itself.
set -uo pipefail
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
D=/tmp/claude-1000/lazy/dp; B=/tmp/claude-1000/lazy/b3; S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe
L=https://github.com/buster14a/buster/issues/2850
T=$HOME/.cache/claude-2850/wt-regress
cd $T && echo "branch at $(git rev-parse --short=9 HEAD)"
CORES_TITLE="#2850: the default path's branch with main merged in, built whole" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "branch build exit $?"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: the driver's eight parts (default path, main merged in)" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$S'/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad/blocks-driver8.tests' > $D/driver8-b43c55d58.log 2>&1
echo "driver parts: $(grep -E '^parallel: .* passed' $D/driver8-b43c55d58.log)"
grep -E "\(part [0-9] of 8\)" $D/driver8-b43c55d58.log | sed -E 's/^.*(\(part [0-9] of 8\)[^,]*),.*$/\1/' | sort -u | head -10
grep -hoE "[0-9]+ checks" $D/driver8-b43c55d58.log | awk '{s += $1} END {print "checks in all:", s}'
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: main.c compiled by itself (default path, main merged in)" CORES_LINK=$L cores -n 2 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$B'/h2/selfcompile.tests' > $D/selfcompile-b43c55d58.log 2>&1
echo "main.c by itself: $(grep -E '^parallel: .* passed' $D/selfcompile-b43c55d58.log)"
echo job-complete

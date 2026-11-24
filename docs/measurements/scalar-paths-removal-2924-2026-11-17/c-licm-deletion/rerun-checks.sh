#!/bin/bash
# The call graph's and the unity ownership check on head, again: run.sh's first attempt pointed them at trees the
# Release build didn't use (native/Release; znver5/Release in place of znver5-g0/Release).
set -u
cd "$(dirname "$0")/src-head"
D=$(cd .. && pwd)
env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph-2.log" 2>&1; echo "check-call-graph (znver5-g0): $?" >> "$D/logs/status.txt"
"$D/br" --ownership-only "$PWD/build/cmake/znver5-g0/Release/compiler" > "$D/logs/ownership-2.log" 2>&1; echo "ownership (znver5-g0): $?" >> "$D/logs/status.txt"
echo done-2 >> "$D/logs/status.txt"

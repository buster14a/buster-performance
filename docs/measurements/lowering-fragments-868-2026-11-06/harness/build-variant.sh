#!/bin/bash
# #868: builds the measured tree (main ec5f0f6b plus the temporary BUSTER_868_FRAGMENTS toggle) with the checker's code
# at offset $1 (BUSTER_CHECKER_OFFSET), as bin/compiler-$1. Run under exclusive.sh.
set -euo pipefail
D=$HOME/buster-fast-bench/868-claude
off=$1
cd "$D/src"
git -C "$D/src" rev-parse HEAD
git -C "$D/src" diff | sha256sum
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES="-DBUSTER_CHECKER_OFFSET=$off" taskset -c 0-7 ./build.sh --config Release
mkdir -p "$D/bin"
cp build/compiler "$D/bin/compiler-$off"
sha256sum "$D/bin/compiler-$off"
nm "$D/bin/compiler-$off" | grep -E ' (check_lower_drain|check_lower_part|check_lower_batch_classify|check_program_emit)$' || true

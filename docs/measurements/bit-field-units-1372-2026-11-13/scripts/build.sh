#!/bin/bash
# The two trees' Release builds, each under the 9700X's lock (one run each).
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
export EXCLUSIVE_OWNER=claude-1372 EXCLUSIVE_TITLE="Bit-field access units (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1372
for tree in base head; do
    (cd "$tree" && ~/buster-fast-bench/exclusive.sh timeout 900 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 8)
done
echo built

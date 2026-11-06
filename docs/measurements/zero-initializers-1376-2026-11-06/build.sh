#!/bin/bash
# One tree's build under the lock: build.sh TREE.
set -euo pipefail
cd ~/buster-fast-bench/1376-opencode/"$1"
EXCLUSIVE_OWNER=opencode-1376 EXCLUSIVE_TITLE="#1376 zero-initialized locals" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1376 \
    ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh 2>&1 | tail -3
sha256sum build/compiler

#!/bin/bash
# build-tree.sh NAME: trees/NAME built as the 9700X job builds it (znver5 Release, no debug information). Under the lock.
set -euo pipefail
cd ~/buster-fast-bench/3581-claude-hape45/trees/$1
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../../results/build-$1.log 2>&1
tail -2 ../../results/build-$1.log

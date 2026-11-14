#!/bin/bash
# One tree's build in its own lock hold: build.sh TREE.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
mkdir -p results
./lock.sh results/build-$1 bash -c "cd $1 && env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh 2>&1 | tail -3" > results/build-$1.log
sha256sum $1/build/compiler | tee -a results/build-$1.log

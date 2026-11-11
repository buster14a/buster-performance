#!/bin/bash
# Build one tree (Release, znver5 host build) under the 9700X lock.
cd ~/buster-fast-bench/1838-claude-b7/$1 && BUSTER_HOST_ARCH=znver5 ./build.sh 2>&1 | tail -2

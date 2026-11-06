#!/bin/bash
# build.sh DIR: a znver5 build of DIR with debug information, under the lock.
cd ~/buster-fast-bench/1489-opencode/$1 || exit 2
EXCLUSIVE_OWNER=opencode-1489 EXCLUSIVE_TITLE="#1489 check-input regression" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 \
  ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=${DEBUG:-1} ./build.sh > ../build-$1.log 2>&1
echo "status=$?" >> ../build-$1.log

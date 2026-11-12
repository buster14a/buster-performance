#!/bin/bash
# Base and head builds, each under its own hold of the lock.
cd ~/buster-fast-bench/2144-claude-e3b
export EXCLUSIVE_OWNER=claude-e3b EXCLUSIVE_TITLE="E3b: Tier 1 asm bodies' register operands (#2144)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2144
for v in base head; do
  ~/buster-fast-bench/exclusive.sh bash -c "cd $v && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-$v.log 2>&1; echo build-$v=\$? >> ../build.status"
done
echo done >> build.status

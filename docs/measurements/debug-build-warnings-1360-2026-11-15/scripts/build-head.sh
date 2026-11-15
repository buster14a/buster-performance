#!/bin/bash
# build-head.sh COMMIT PATCH: the head tree (main 2ebfe68a + PATCH, the branch's diff), built znver5 without debug info as `main` (base) was.
set -u
cd ~/buster-fast-bench/1360-claude || exit 2
export EXCLUSIVE_OWNER=claude-1360 EXCLUSIVE_TITLE="claude #1360 debug-build warnings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
commit=$1; patch=$2
rm -rf head && mkdir head && git -C repo archive 2ebfe68a856613e300231520af5e7ec5627708b6 | tar -x -C head && (cd head && patch -p1 -s < ../$patch) || exit 2
echo "$commit (main 2ebfe68a + $patch)" > head/COMMIT
(cd head && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 timeout 3000 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > head.build.log 2>&1 || { echo "build failed"; exit 1; }
ln -sfn main base
echo built > head.built

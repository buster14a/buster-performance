#!/usr/bin/env bash
# build.sh NAME COMMIT: the tree at COMMIT built Release (znver5, no debug info, as the Zen 5 record's), its compiler
# copied to bin/NAME, under the lock. The head's commit comes from head.patch (git am onto the base).
set -u
source "$(dirname "$0")/common.sh"
NAME=$1
COMMIT=$2
cd $W/tree || exit 1
git checkout -q --detach "$COMMIT" || exit 1
git rev-parse HEAD > $W/out/commit-$NAME.txt
$LOCK bash -c "state build-$NAME; BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release" > $W/out/build-$NAME.log 2>&1
echo "exit $?" >> $W/out/build-$NAME.log
mkdir -p $W/bin
cp -L build/compiler $W/bin/$NAME
sha256sum $W/bin/$NAME >> $W/out/build-$NAME.log

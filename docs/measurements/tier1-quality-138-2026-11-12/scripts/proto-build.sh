#!/bin/bash
# proto-build.sh: the measured commit in src-proto with kinds-instrumentation.patch and inline-cfg-prototype.patch (the
# experiment's switches, all off by default, when its code is the plain build's: BUSTER_EXP_INLINE_STATIC=COST offers
# every internal function without an inline attribute to --tier1's inliner at that cost limit, counted in the nodes of
# its memory-form IR; BUSTER_EXP_INLINE_CFG=1 lets the inliner take callees with control flow and with calls of their
# own, a block-level splice; BUSTER_EXP_INLINE_EXTERNAL=1 offers the unit's external functions too;
# BUSTER_EXP_INLINE_GROWTH=N sets the caller's growth limit), built in one hold of the lock.
set -eu
cd "$(dirname "$0")"
test -e src-proto || ./clone.sh "$(cat src.commit)" src-proto
git -C src-proto apply --3way ../kinds-instrumentation.patch
git -C src-proto apply --3way ../inline-cfg-prototype.patch
sha256sum kinds-instrumentation.patch inline-cfg-prototype.patch > build-src-proto.patch.sha256
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src-proto && time BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_TIER1_MEASURE_KINDS=1' ./build.sh" > build-src-proto.log 2>&1
echo "build exit $?" >> build-src-proto.log
sha256sum src-proto/build/compiler >> build-src-proto.log 2>&1

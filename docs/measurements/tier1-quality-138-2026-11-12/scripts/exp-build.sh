#!/bin/bash
# exp-build.sh: the measured commit in src-exp with kinds-instrumentation.patch and inline-static-experiment.patch
# (BUSTER_EXP_INLINE_STATIC=COST: --tier1's existing inliner, #1282's, takes every internal function without an inline
# attribute at that cost limit, not the always_inline ones alone; without the variable its code is the plain build's),
# built in one hold of the lock.
set -eu
cd "$(dirname "$0")"
test -e src-exp || ./clone.sh "$(cat src.commit)" src-exp
git -C src-exp apply --3way ../kinds-instrumentation.patch
git -C src-exp apply --3way ../inline-static-experiment.patch
sha256sum kinds-instrumentation.patch inline-static-experiment.patch > build-src-exp.patch.sha256
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src-exp && time BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_TIER1_MEASURE_KINDS=1' ./build.sh" > build-src-exp.log 2>&1
echo "build exit $?" >> build-src-exp.log
sha256sum src-exp/build/compiler >> build-src-exp.log 2>&1

#!/bin/bash
# kinds-build.sh: the measured commit again in src-kinds with kinds-instrumentation.patch (#1189's origin tags, as the
# #1216 record carried them: BUSTER_TIER1_MEASURE_KINDS), built in one hold of the lock. With BUSTER_TIER1_KINDS=FILE
# its --tier1 writes a line of tags per function it compiles; its code is the plain build's (kinds.sh checks that).
set -eu
cd "$(dirname "$0")"
test -e src-kinds || ./clone.sh "$(cat src.commit)" src-kinds
git -C src-kinds apply --3way ../kinds-instrumentation.patch
git -C src-kinds diff HEAD | sha256sum > build-src-kinds.patch.sha256
sha256sum kinds-instrumentation.patch >> build-src-kinds.patch.sha256
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src-kinds && time BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_TIER1_MEASURE_KINDS=1' ./build.sh" > build-src-kinds.log 2>&1
echo "build exit $?" >> build-src-kinds.log
sha256sum src-kinds/build/compiler >> build-src-kinds.log 2>&1

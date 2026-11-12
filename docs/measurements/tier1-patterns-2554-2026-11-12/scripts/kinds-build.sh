#!/bin/bash
# kinds-build.sh NAME: src-NAME (a measured tree with #138's record's kinds-instrumentation.patch, #1189's origin tags)
# built in one hold of the lock with BUSTER_TIER1_MEASURE_KINDS; with BUSTER_TIER1_KINDS=FILE its --tier1 writes a line
# of tags per function, and its code is the plain build's (kinds.sh checks that).
cd "$(dirname "$0")"
name=${1:?a tree}
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src-$name && time BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_TIER1_MEASURE_KINDS=1' ./build.sh" > "build-src-$name.log" 2>&1
echo "build exit $?" >> "build-src-$name.log"
sha256sum "src-$name/build/compiler" >> "build-src-$name.log" 2>&1

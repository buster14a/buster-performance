#!/bin/bash
# Builds the head and nosub trees (main's, at ba379033, is built already), each in a hold of its own.
. "$(dirname "$0")/env.sh"
for t in head nosub; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    tail -1 $M/build-$t.log
    sha256sum $T/$t/build/compiler
done
sha256sum $T/main/build/compiler

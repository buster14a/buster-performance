#!/bin/bash
# Builds Tier 0's two trees (before and after the jump tables' merge) without debug information, and lists each
# tree's files' hashes.
set -u
. "$(dirname "$0")/st-env.sh"
mkdir -p $M
for t in ${TREES[@]}; do
    cd $B/$t || exit 1
    BUSTER_DEBUG_INFO=0 ./build.sh || exit 1
    find build.sh src tests -type f | sort | xargs sha256sum > $M/manifest-$t.sha256
done

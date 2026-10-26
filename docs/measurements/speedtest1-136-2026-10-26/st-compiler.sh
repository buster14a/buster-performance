#!/bin/bash
# Builds the measured compiler (main at e04462c1) without debug information, and lists its tree's files' hashes.
set -u
. "$(dirname "$0")/st-env.sh"
mkdir -p $M
cd $B/tree || exit 1
BUSTER_DEBUG_INFO=0 ./build.sh || exit 1
find build.sh src tests -type f | sort | xargs sha256sum > $M/manifest-e04462c1.sha256

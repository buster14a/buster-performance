#!/usr/bin/env bash
# Builds one tree of #775's measurement as the 9700X job does (BUSTER_DEBUG_INFO=0), then logs its commit, status and the
# executable's SHA-256. $1: the tree's directory under the measurement's.
set -uo pipefail
cd "$HOME/buster-fast-bench/target-features-775-claude/$1" || exit 1
echo "tree $1 commit $(cat COMMIT)"
BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
status=$?
tail -2 build.log
echo "build $1 status $status"
sha256sum build/compiler

#!/usr/bin/env bash
# Builds one tree of #148's measurement as CI does (BUSTER_DEBUG_INFO=0).
set -uo pipefail
cd "$HOME/buster-fast-bench/alloca-frame-148-claude/$1" || exit 1
BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1
status=$?
tail -2 build.log
echo "build $1 status $status"

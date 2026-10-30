#!/bin/bash
# Builds one measured tree on the 9700X, under the host's lock for the build alone.
set -e
cd ~/buster-fast-bench/solve-147-claude/$1
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve #137 #147 #148 (#147: musl inline asm A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "$1: $(tail -1 build.log)"

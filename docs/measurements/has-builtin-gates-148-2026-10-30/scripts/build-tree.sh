#!/bin/bash
# Builds one measured tree on the 9700X, under the host's lock for the build alone.
set -e
cd ~/buster-fast-bench/solve-148-claude/$1
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="solve #137 #147 #148 (#148: __has_builtin gates A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "$1: $(tail -1 build.log)"

#!/bin/bash
# Release build of one tree ($1), under the 9700X lock.
set -e
cd ~/buster-fast-bench/3308-claude/$1
export EXCLUSIVE_OWNER=claude-3308 EXCLUSIVE_TITLE="buster #3308: Tier 0 zeroes int-to-float destinations" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3308
~/buster-fast-bench/exclusive.sh ./build.sh --config Release

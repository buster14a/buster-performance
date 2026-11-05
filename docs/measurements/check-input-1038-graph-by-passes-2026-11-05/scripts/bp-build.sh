#!/bin/bash
# Usage: bp-build.sh DIR  -- builds DIR under the lock
set -e
dir="$1"
cd "$dir"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "build rc=$?"
tail -3 build.log

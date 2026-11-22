#!/bin/bash
# #3298's second measurement round: the Release build, then sqlite3.c's compile time and the kernel, each under the
# lock per run.
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-3298 EXCLUSIVE_TITLE="buster #3298: Tier 1 switch of constants as a value table" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngozmJexqNjV6aib1K
timeout 1200 ~/buster-fast-bench/exclusive.sh bash -c "cd buster && ./build.sh --config Release" > build2.log 2>&1
timeout 1200 ~/buster-fast-bench/exclusive.sh ./compile.sh > compile2.log 2>&1
timeout 900 ~/buster-fast-bench/exclusive.sh ./run.sh > kernel2.log 2>&1
echo done > all.done

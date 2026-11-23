#!/bin/bash
# The first commit's build, for the kernels' `held` column, in one hold of the lock.
W=/tmp/3346-claude
export EXCLUSIVE_OWNER=claude-3346 EXCLUSIVE_TITLE='buster #3346: loop store motion sinks stores (build)' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnh2KB6UMiNcgm6mK5q
timeout 3000 $HOME/buster-fast-bench/exclusive.sh bash -c "cd $W/keep && git log --oneline -1 && BUSTER_DEBUG_INFO=0 ./build.sh --config Release" > $W/logs/build-keep.txt 2>&1
echo "build keep exit $? $(date -u +%FT%TZ)" >> $W/logs/queue.txt

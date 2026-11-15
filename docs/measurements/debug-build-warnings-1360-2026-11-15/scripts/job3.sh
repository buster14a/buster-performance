#!/bin/bash
# job3.sh: cycles:u profiles of the measured head (964eb8c) on sqlite3.c -DSQLITE_DEBUG with and without -w, 8 compiles each,
# one lock hold per set, for the per-symbol difference (agg.sh).
set -u
cd ~/buster-fast-bench/1360-claude || exit 2
export EXCLUSIVE_OWNER=claude-1360 EXCLUSIVE_TITLE="claude #1360 debug-build warnings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
timeout 3000 ~/buster-fast-bench/exclusive.sh ./prof.sh $PWD/head/build/compiler hdbg 8 -DSQLITE_DEBUG > job3.log 2>&1
timeout 3000 ~/buster-fast-bench/exclusive.sh ./prof.sh $PWD/head/build/compiler hdbgw 8 -DSQLITE_DEBUG -w >> job3.log 2>&1
./agg.sh hdbg hdbgw > prof/diff-hdbg.txt
echo done > job3.done

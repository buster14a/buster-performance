#!/bin/bash
# On the 9700X, detached: builds PR #511's head in libgcc-s-489-head2 under its own hold of the lock, then runs
# libgcc-s-489-bench2.sh (base and head in turn).
B=~/buster-fast-bench
cd $B/libgcc-s-489-head2 || exit 1
EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE='Solve 489' EXCLUSIVE_LINK='https://github.com/buster14a/buster/pull/511' BUSTER_DEBUG_INFO=0 $B/exclusive.sh ./build.sh > build.log 2>&1
status=$?
tail -1 build.log
echo "head2 build status $status"
sha256sum build/compiler
[ $status = 0 ] || exit 1
$B/libgcc-s-489-bench2.sh
echo "bench2 done $?"

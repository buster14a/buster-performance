#!/bin/bash
# run490b.sh: the final head (ac507761): round 1 to 5's logs of 77a46178 kept apart (logs-head-77a46178), its tree
# rebuilt under a hold of its own, five more rounds (6 to 10) of pre, main and the final head, then the diagnostic
# builds' faults by step (faults490c.sh) under one hold.
set -u
B=~/buster-fast-bench/perf-490-claude
export EXCLUSIVE_OWNER=claude-490 EXCLUSIVE_TITLE="Performance issues #490 #446 #445" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/490
unset CPATH C_INCLUDE_PATH
cd "$B" || exit 1
[ -d logs-head-77a46178 ] || mv logs-head logs-head-77a46178
rm -rf work-head
cd "$B/head" || exit 1
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "final head build status $? $(date -Is)" >> "$B/progress.log"
sha256sum build/compiler >> "$B/progress.log"
"$B/queue490.sh" 6 10
~/buster-fast-bench/exclusive.sh "$B/diag/faults490c.sh" > "$B/diag/faults490c.log" 2>&1
echo "faults490c status $? $(date -Is)" >> "$B/progress.log"

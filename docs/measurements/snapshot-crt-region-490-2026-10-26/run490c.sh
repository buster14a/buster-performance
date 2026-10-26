#!/bin/bash
# run490c.sh: the head f579317c (the alignment checked by a mask): rounds 6 to 10's logs of ac507761 kept apart
# (logs-head-ac507761), its tree rebuilt under a hold of its own, then five more rounds (11 to 15) of pre, main and the
# head.
set -u
B=~/buster-fast-bench/perf-490-claude
export EXCLUSIVE_OWNER=claude-490 EXCLUSIVE_TITLE="Performance issues #490 #446 #445" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/490
unset CPATH C_INCLUDE_PATH
cd "$B" || exit 1
[ -d logs-head-ac507761 ] || mv logs-head logs-head-ac507761
rm -rf work-head
cd "$B/head" || exit 1
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
echo "f579317c head build status $? $(date -Is)" >> "$B/progress.log"
sha256sum build/compiler >> "$B/progress.log"
"$B/queue490.sh" 11 15

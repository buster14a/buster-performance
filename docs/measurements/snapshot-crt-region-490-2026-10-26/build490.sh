#!/bin/bash
# build490.sh: builds #490's two trees on the 9700X, each under its own hold of the shared lock, without -g as the
# 9700X job builds: main (35f26f68 with benchmark-link's fault counts and the diagnostic populate switch) and the
# branch's head.
set -u
B=~/buster-fast-bench/perf-490-claude
export EXCLUSIVE_OWNER=claude-490 EXCLUSIVE_TITLE="Performance issues #490 #446 #445" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/490
unset CPATH C_INCLUDE_PATH
for t in main head; do
    cd "$B/$t" || exit 1
    BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
    echo "$t build status $? $(date -Is)" >> "$B/progress.log"
    sha256sum build/compiler >> "$B/progress.log"
done

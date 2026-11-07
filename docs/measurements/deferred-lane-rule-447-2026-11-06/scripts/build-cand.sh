#!/bin/bash
# Builds the candidate tree (cand/, the refitted rule) as the 9700X job builds it, under the lock.
D=~/buster-fast-bench/447-claude
cd "$D/cand" || exit 1
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 deferred lane-count acceptance: candidate build" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
{ date -Is; git log -1 --format=%H; clang --version | head -1; } > "$D/build-cand.txt"
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh >> "$D/build-cand.txt" 2>&1
echo "exit=$? $(date -Is)" >> "$D/build-cand.txt"

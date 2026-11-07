#!/bin/bash
# build-dir.sh TREE...: builds each worktree TREE (a directory of ~/buster-fast-bench/447-claude) as the 9700X job
# builds it (BUSTER_DEBUG_INFO=0, the native host), each in a lock hold of its own; logs/build-TREE.txt.
D=~/buster-fast-bench/447-claude
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 remaining work: lane choice on mid-sized units" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
for tree in "$@"; do
    log="$D/logs/build-$tree.txt"
    (cd "$D/$tree" && { date -Is; git log -1 --format=%H; git diff --stat; clang --version | head -1; } > "$log" && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh >> "$log" 2>&1; echo "exit=$? $(date -Is)" >> "$log")
done

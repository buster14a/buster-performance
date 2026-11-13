#!/bin/bash
# queue6.sh: build nonames (the branch without the names' columns' move), then five rounds of base, head and nonames on
# musl and the glibc units by one lane and by eight.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
echo "=== build nonames"
timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3-claude && EXCLUSIVE_OWNER=claude-2531-step3 EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./build.sh nonames" 2>&1 | grep -E "^(status|build\.sh)"
run() { echo "=== hold: $*"; $S/bp3.sh batch "$@" 2>&1 | grep -E "^(== |=== )"; }
for r in 1 2 3 4 5; do run "trees musl 1 $r base head nonames" "trees glibc 1 $r base head nonames" "trees musl 8 $r base head nonames" "trees glibc 8 $r base head nonames"; done
echo "=== done"

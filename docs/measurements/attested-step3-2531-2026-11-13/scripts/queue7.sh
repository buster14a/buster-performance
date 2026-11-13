#!/bin/bash
# queue7.sh: build intr (the intrinsics' pass alone), then five rounds of base, intr and nonames by eight lanes and one.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
echo "=== build intr"
timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3-claude && EXCLUSIVE_OWNER=claude-2531-step3 EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./build.sh intr" 2>&1 | grep -E "^(status|build\.sh)"
run() { echo "=== hold: $*"; $S/bp3.sh batch "$@" 2>&1 | grep -E "^(== |=== )"; }
for r in 1 2 3 4 5 6 7; do run "trees musl 8 $r base intr nonames" "trees glibc 8 $r base intr nonames" "trees musl 1 $r base intr nonames" "trees glibc 1 $r base intr nonames"; done
echo "=== done"

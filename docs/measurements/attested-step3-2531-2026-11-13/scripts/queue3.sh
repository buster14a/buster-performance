#!/bin/bash
# queue3.sh: step 3's first A/B on benchpress: build base (main), head and noint (head without the intrinsic pass's
# skip), then five rounds of musl's and the glibc units' commands by each, a hold a round.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
build() { timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3-claude && EXCLUSIVE_OWNER=claude-2531-step3 EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./build.sh $1" 2>&1 | grep -v '^  \(title\|link\):\|^[0-9-]*T.*: \|waiting for'; }
run() { echo "=== hold: $*"; $S/bp3.sh batch "$@" 2>&1 | grep -v "waiting for"; }
for t in base head noint; do echo "=== build $t"; build $t; done
for r in 1 2 3 4 5; do run "trees musl 1 $r base head noint" "trees glibc 1 $r base head noint"; done
echo "=== done"

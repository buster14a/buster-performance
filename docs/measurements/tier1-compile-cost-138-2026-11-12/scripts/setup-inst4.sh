#!/bin/bash
# setup-inst4.sh: a tree of the same commit with laps4.patch applied: laps3.patch and the prototype of the pipeline a
# phase at a time over a batch of functions (BUSTER_T1_BATCH, BUSTER_T1_BATCH_ENTRIES). No lock: no build, no run.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst4 ]; then
    git -C src worktree add -q --detach ../inst4 "$(head -1 COMMIT)"
fi
git -C inst4 checkout -q -- .
git -C inst4 clean -q -fd src
git -C inst4 apply ../laps4.patch
git -C inst4 status --short | wc -l
sha256sum laps4.patch

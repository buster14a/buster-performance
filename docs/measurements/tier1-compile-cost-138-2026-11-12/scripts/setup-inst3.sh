#!/bin/bash
# setup-inst3.sh: a tree of the same commit with laps3.patch applied: laps.patch, per function what became of the
# callee-saved preference's second allocation and the first one's pressure (a G line a function), and the prototype of
# one allocation (BUSTER_T1_PREFERRED_FIRST). No lock: no build, no run.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst3 ]; then
    git -C src worktree add -q --detach ../inst3 "$(head -1 COMMIT)"
fi
git -C inst3 checkout -q -- .
git -C inst3 clean -q -fd src
git -C inst3 apply ../laps3.patch
git -C inst3 status --short | wc -l
sha256sum laps3.patch

#!/bin/bash
# setup-inst6.sh: a tree of the same commit with laps6.patch applied: laps5.patch and the design's own prototype, both
# problems in one allocator call (BUSTER_T1_PREFERRED_FIRST=3: the plain assignment for its verdict, the preferred one
# over the same intervals, lookup and edge moves once; =4: the plain assignment also skipped where it provably meets no
# constraint). No lock.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst6 ]; then
    git -C src worktree add -q --detach ../inst6 "$(head -1 COMMIT)"
fi
git -C inst6 checkout -q -- .
git -C inst6 clean -q -fd src
git -C inst6 apply ../laps6.patch
git -C inst6 status --short | wc -l
sha256sum laps6.patch

#!/bin/bash
# setup-inst8.sh: a tree of the same commit with laps8.patch applied: laps7.patch and the verdict inside the preferred
# assignment's call (BUSTER_T1_PREFERRED_FIRST=6: =5's prefix, scanned over the events that call has just sorted, so
# that the intervals are validated and their events sorted once for both problems). No lock.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst8 ]; then
    git -C src worktree add -q --detach ../inst8 "$(head -1 COMMIT)"
fi
git -C inst8 checkout -q -- .
git -C inst8 clean -q -fd src
git -C inst8 apply ../laps8.patch
git -C inst8 status --short | wc -l
sha256sum laps8.patch

#!/bin/bash
# setup-inst5.sh: a tree of the same commit with laps5.patch applied: laps4.patch and the exact variant of one allocation
# (BUSTER_T1_PREFERRED_FIRST=2: the plain allocation put off only where it provably meets no constraint). No lock.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst5 ]; then
    git -C src worktree add -q --detach ../inst5 "$(head -1 COMMIT)"
fi
git -C inst5 checkout -q -- .
git -C inst5 clean -q -fd src
git -C inst5 apply ../laps5.patch
git -C inst5 status --short | wc -l
sha256sum laps5.patch

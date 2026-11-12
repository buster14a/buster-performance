#!/bin/bash
# setup-inst7.sh: a tree of the same commit with laps7.patch applied: laps6.patch and the plain assignment's verdict from
# a prefix (BUSTER_T1_PREFERRED_FIRST=5: =3's one allocator call, with the plain assignment run only over the events
# before the last parameter's definition interval ends, and whole only if the preferred one is refused). No lock.
set -eu
cd "$(dirname "$0")"
if [ ! -d inst7 ]; then
    git -C src worktree add -q --detach ../inst7 "$(head -1 COMMIT)"
fi
git -C inst7 checkout -q -- .
git -C inst7 clean -q -fd src
git -C inst7 apply ../laps7.patch
git -C inst7 status --short | wc -l
sha256sum laps7.patch

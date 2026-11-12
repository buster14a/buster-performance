#!/bin/bash
# setup-pgo.sh: a tree of the same commit, unpatched, for pgo.sh's profile-guided build. No lock.
set -eu
cd "$(dirname "$0")"
if [ ! -d pgo ]; then
    git -C src worktree add -q --detach ../pgo "$(head -1 COMMIT)"
fi
git -C pgo status --short | wc -l
git -C pgo rev-parse HEAD

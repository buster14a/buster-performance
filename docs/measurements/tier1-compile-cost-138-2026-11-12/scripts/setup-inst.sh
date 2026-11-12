#!/bin/bash
# setup-inst.sh: a second tree of the same commit with laps.patch applied (the lap log; no lock: no build, no run).
set -eu
cd "$(dirname "$0")"
if [ ! -d inst ]; then
    git -C src worktree add -q --detach ../inst "$(head -1 COMMIT)"
fi
git -C inst checkout -q -- .
git -C inst clean -q -fd src
git -C inst apply ../laps.patch
git -C inst status --short | head -20
sha256sum laps.patch

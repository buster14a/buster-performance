#!/bin/bash
# #1549's trees: main (base) and the follow-up's head.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main claude/funny-bohr-4c8ngf
[ -d base ] || git -C repo worktree add -q --detach ../base "$BASE"
[ -d head ] || git -C repo worktree add -q --detach ../head "$HEAD"
git -C base log --oneline -1; git -C head log --oneline -1

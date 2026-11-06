#!/bin/bash
# #1376's trees: main (base), the PR's head, and the head with the memset threshold at 8 bytes (fill8).
set -euo pipefail
cd ~/buster-fast-bench/1376-opencode
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main opencode/1376-zero-init
[ -d base ] || git -C repo worktree add -q --detach ../base "$BASE"
[ -d head ] || git -C repo worktree add -q --detach ../head "$HEAD"
[ -d fill8 ] || git -C repo worktree add -q --detach ../fill8 "$HEAD"
sed -i 's/^#define BUSTER_CHECK_LOWER_FILL_UNROLLED 128u/#define BUSTER_CHECK_LOWER_FILL_UNROLLED 8u/' fill8/src/buster/compiler/c_check_program_initializers.c
grep -n "define BUSTER_CHECK_LOWER_FILL_UNROLLED" fill8/src/buster/compiler/c_check_program_initializers.c
git -C base log --oneline -1; git -C head log --oneline -1

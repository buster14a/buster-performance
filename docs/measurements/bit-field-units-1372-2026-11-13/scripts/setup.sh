#!/bin/bash
# Two trees of buster at the base commit, the head one with the PR's commit applied from head.patch.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
base=b7a95eedbe16fbd8434654f192f8f7aab76c56e5
if [ ! -d repo ]; then git clone -q https://github.com/buster14a/buster.git repo; fi
git -C repo fetch -q origin main
if [ ! -d base ]; then git -C repo worktree add -q --detach ../base "$base"; fi
if [ ! -d head ]; then git -C repo worktree add -q --detach ../head "$base"; git -C head -c user.name=bench -c user.email=bench@localhost am -q < head.patch; fi
git -C base log -1 --format='base %H'
git -C head log -1 --format='head %H %s'

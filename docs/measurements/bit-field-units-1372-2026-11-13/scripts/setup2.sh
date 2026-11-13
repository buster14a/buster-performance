#!/bin/bash
# The head2 tree: the base commit with the PR's commits applied from head2.patch (git format-patch of the series).
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
base=b7a95eedbe16fbd8434654f192f8f7aab76c56e5
if [ ! -d head2 ]; then git -C repo worktree add -q --detach ../head2 "$base"; git -C head2 -c user.name=bench -c user.email=bench@localhost am -q < head2.patch; fi
git -C head2 log --format='head2 %H %s' "$base"..HEAD
git -C head2 rev-parse 'HEAD^{tree}'

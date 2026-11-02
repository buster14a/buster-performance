#!/usr/bin/env bash
# send.sh VARIANT: copies the worktree's tree to the 9700X as exp/VARIANT.
set -euo pipefail
cd /home/david/dev/ai/claude/buster/.claude/worktrees/solve-880-1c2bbb
tar cf - --exclude=./build --exclude=./.git . | timeout 120 tailscale ssh david@benchpress "rm -rf ~/buster-fast-bench/claude-880/exp/$1 && mkdir -p ~/buster-fast-bench/claude-880/exp/$1 && tar xf - -C ~/buster-fast-bench/claude-880/exp/$1"
echo "sent $1"

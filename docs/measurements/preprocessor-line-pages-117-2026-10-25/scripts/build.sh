#!/usr/bin/env bash
# build.sh TREE: builds TREE/build/compiler under the lock.
set -e
cd "$HOME/buster-fast-bench/pp-117-claude/$1"
"$HOME/buster-fast-bench/pp-117-claude/locked.sh" ./build.sh

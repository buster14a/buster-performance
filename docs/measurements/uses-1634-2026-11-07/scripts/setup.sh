#!/bin/bash
# Use-list builder investigation: a main tree at the given commit, built with the benchmark flags under the lock.
set -e
D=$HOME/buster-fast-bench/uses-claude
mkdir -p "$D"
cd "$D"
test -d main || git clone -q https://github.com/buster14a/buster main
git -C main fetch -q origin main
git -C main checkout -q --detach "$1"
git -C main log --oneline -1
cd main
EXCLUSIVE_OWNER=claude-uses EXCLUSIVE_TITLE="Use-list builder: main build" EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQt3vr5GH2UtvS3ETV7 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-main.log 2>&1
tail -1 ../build-main.log

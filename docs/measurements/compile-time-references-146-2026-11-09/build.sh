#!/bin/bash
# Fetch a revision of buster into ~/buster-fast-bench/146-claude/buster and build it (znver5), under the 9700X's lock.
set -euo pipefail
dir=~/buster-fast-bench/146-claude
rev="$1"
mkdir -p "$dir"
cd "$dir"
if [ ! -d buster ]; then git clone -q https://github.com/buster14a/buster buster; fi
cd buster
git fetch -q origin "+refs/heads/*:refs/remotes/origin/*"
git checkout -q --detach "$rev"
git log --oneline -1
export EXCLUSIVE_OWNER=claude-146 EXCLUSIVE_TITLE="#146 compile time against tcc, clang -O0 and gcc -O0" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/146
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
ls -la build/compiler

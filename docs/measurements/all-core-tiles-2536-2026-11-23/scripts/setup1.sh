#!/bin/bash
# Clone main at a commit, build Release under the lock, build the gauge.
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
commit=${1:?commit}
name=${2:?tree name}
cd "$dir"
if [ ! -d "$name" ]; then git clone -q https://github.com/buster14a/buster.git "$name"; fi
cd "$name"
git fetch -q origin
git checkout -q --detach "$commit"
git log --oneline -1
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
~/buster-fast-bench/exclusive.sh ./build.sh --config Release
cc -std=c17 -O2 -Wall -Wextra -Werror -o build/allcore tools/allcore/allcore.c
build/allcore self-test
sha256sum build/compiler
echo SETUP-DONE

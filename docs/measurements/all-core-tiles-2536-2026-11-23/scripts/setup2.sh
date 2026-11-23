#!/bin/bash
# A tree at a commit with a patch applied, built Release under the lock.
# setup2.sh COMMIT TREE PATCH
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
commit=${1:?commit}
name=${2:?tree name}
patch=${3:?patch}
cd "$dir"
if [ ! -d "$name" ]; then git clone -q "$dir/main" "$name"; fi
cd "$name"
git fetch -q origin
git checkout -q --detach "$commit"
git reset -q --hard "$commit"
git apply "$dir/$patch"
git log --oneline -1
git diff --stat
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path, a build"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
~/buster-fast-bench/exclusive.sh ./build.sh --config Release
cc -std=c17 -O2 -Wall -Wextra -Werror -o build/allcore tools/allcore/allcore.c
sha256sum build/compiler
echo SETUP-DONE

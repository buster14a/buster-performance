#!/bin/bash
# exp.sh NAME BASE PATCH [CONFIG]: a tree trees/NAME at BASE with PATCH applied, built (Develop by default) under the lock.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
name=$1; base=$2; patch=$3; config=${4:-Develop}
tree="$dir/trees/$name"
cd "$dir"
if [[ ! -d "$tree" ]]; then
    git -C src worktree add -q --detach "$tree" "$base"
fi
git -C "$tree" checkout -q -- .
git -C "$tree" apply "$patch"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: build experiment $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
(cd "$tree" && "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config "$config" --target compiler) > "$tree-build.log" 2>&1
echo "built $name ($config): $(sha256sum "$tree/build/compiler" | cut -c1-16)"

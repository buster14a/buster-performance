#!/bin/bash
# Sets up this session's directory on the 9700X: an independent clone, and a Release build of a revision in trees/REV.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
mkdir -p "$dir/trees" "$dir/results"
cd "$dir"
if [[ ! -d src/.git ]]; then
    git clone -q --dissociate --reference "$HOME/buster-fast-bench/2850-claude-5a14/src" https://github.com/buster14a/buster.git src
fi
rev=$1
git -C src fetch -q origin
full=$(git -C src rev-parse "$rev")
short=${full:0:9}
tree="$dir/trees/$short"
if [[ ! -d "$tree" ]]; then
    git -C src worktree add -q --detach "$tree" "$full"
fi
if [[ ! -f "$tree.built" ]]; then
    export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: build $short" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850"
    (cd "$tree" && "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > "$tree-build.log" 2>&1
    sha256sum "$tree/build/compiler" > "$tree.built"
fi
echo "built $short: $(cat "$tree.built")"

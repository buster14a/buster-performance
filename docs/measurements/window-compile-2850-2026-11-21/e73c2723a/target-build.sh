#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
dir=$PWD
shared="$HOME/buster-fast-bench/2850-codex-step2"
repo="$shared/src"
parent=$1
candidate=$2
pr=$3
export EXCLUSIVE_OWNER=codex-2850-typed-reserve EXCLUSIVE_TITLE='Build ordinary typed reserve planner' EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/$pr" RESERVE_PR="https://github.com/buster14a/buster/pull/$pr"
git -C "$repo" fetch -q origin "$candidate" "$parent"
for arm in parent candidate; do
    if [[ $arm = parent ]]; then rev=$parent; else rev=$candidate; fi
    tree="$dir/$arm"
    if [[ ! -d "$tree" ]]; then git -C "$repo" worktree add -q --detach "$tree" "$rev"; fi
    test "$(git -C "$tree" rev-parse HEAD)" = "$rev"
    if [[ ! -f "$dir/$arm.built" ]]; then
        (cd "$tree" && "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > "$dir/$arm-build.log" 2>&1
        cp "$shared/proof-predefines.h" "$tree/build/predefines.h"
        sha256sum "$tree/build/compiler" > "$dir/$arm.built"
    fi
done
python3 "$dir/target.py" "$dir/parent/build/compiler" "$dir/candidate/build/compiler" "$dir/target"

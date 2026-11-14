#!/bin/bash
# #1373: base and head trees, each `git archive` of its commit, built znver5 without debug info, one lock hold per build.
set -u
cd ~/buster-fast-bench/1373-claude || exit 2
export EXCLUSIVE_OWNER=claude-1373 EXCLUSIVE_TITLE="claude #1373 library calls computed inline A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1373
[[ -d repo ]] || git clone -q https://github.com/buster14a/buster.git repo || exit 2
git -C repo fetch -q origin main claude/friendly-davinci-nbuwlv || exit 2
for pair in base:$BASE head:$HEAD; do
    name=${pair%%:*}; commit=${pair#*:}
    commit=$(git -C repo rev-parse "$commit") || exit 2
    dir=$name-${commit:0:8}
    if [[ ! -x $dir/build/compiler ]]; then
        rm -rf "$dir"; mkdir -p "$dir"
        git -C repo archive "$commit" | tar -x -C "$dir" || exit 2
        echo "$commit" > "$dir/COMMIT"
        (cd "$dir" && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) > "$dir.build.log" 2>&1 || { echo "build $dir failed"; exit 1; }
    fi
    echo "built $dir $(tail -2 $dir.build.log | head -1)"
done
echo done

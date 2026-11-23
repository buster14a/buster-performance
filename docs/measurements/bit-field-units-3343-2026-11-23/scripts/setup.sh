#!/bin/bash
# #3343: base (main at the merge) and head (the PR's head) cloned and built Release, each build its own hold of the lock.
set -euo pipefail
dir=~/buster-fast-bench/1372-3343-claude
cd "$dir"
export EXCLUSIVE_OWNER=claude-3343 EXCLUSIVE_TITLE="buster #3343: bit-field units leftovers (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3343
for side in base:1b9821afe448258d08f47f6110922478aa0e4121 head:261a2220c34a9a15661b32a493036b58c5537c41; do
    name=${side%%:*}; sha=${side#*:}
    if [ ! -d "$name" ]; then
        git init -q "$name"
        git -C "$name" fetch -q --depth 1 https://github.com/buster14a/buster "$sha"
        git -C "$name" checkout -q FETCH_HEAD
    fi
    git -C "$name" rev-parse HEAD > "out/$name.sha"
    ~/buster-fast-bench/exclusive.sh timeout 900 bash -c "cd $dir/$name && ./build.sh --config Release" > "out/build-$name.log" 2>&1
    mkdir -p bin && cp "$name/build/compiler" "bin/compiler-$name"
done
echo built

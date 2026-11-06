#!/bin/bash
# #1360/#1341: base and head trees, each built znver5 without debug info, one lock hold per build.
set -u
cd ~/buster-fast-bench/1360-opencode || exit 2
export EXCLUSIVE_OWNER=opencode-1360 EXCLUSIVE_TITLE="opencode #1360/#1341 unselected roots A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
for pair in base:866e087abddd9327552801cc1e43fa82163755ed head:3fcb8033675779f1511854d6c801bc910484ded1; do
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

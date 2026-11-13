#!/bin/bash
# placements.sh PATCH OFFSET...: for #892, main (26f0bb0e) and head (main with PATCH) built at each checker offset
# (BUSTER_CHECKER_OFFSET, #1233), each a worktree of its own and a locked build, published as bin/compiler-TREE-oOFFSET.
set -u
base=~/buster-fast-bench/892-claude
patch=${1:?patch}
shift
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
for offset in "$@"; do
    for tree in main head; do
        dir=$base/$tree-o$offset
        if [ ! -d "$dir" ]; then
            git -C "$base/repo" worktree add -q --detach "$dir" 26f0bb0e || exit 1
            if [ "$tree" = head ]; then
                git -C "$dir" apply "$patch" || exit 1
            fi
        fi
        (cd "$dir" && ~/buster-fast-bench/exclusive.sh timeout 1500 env BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$offset ./build.sh > "$base/build-$tree-o$offset.log" 2>&1)
        echo "build $tree-o$offset status $?" >> "$base/placements.log"
        cp -f "$dir/build/compiler" "$base/bin/compiler-$tree-o$offset"
    done
done
echo done >> "$base/placements.log"

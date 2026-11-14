#!/bin/bash
# head2-placements.sh: head2 (the change without check_graph_run's blocks) at checker offsets 1040 and 2080, then
# main, head and head2 over the three placements.
set -u
base=~/buster-fast-bench/892-claude
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
cd "$base/head2" && git checkout -q -- . && git apply "$base/noA-final.patch" || exit 1
for offset in 1040 2080; do
    dir=$base/head2-o$offset
    [ -d "$dir" ] || { git -C "$base/repo" worktree add -q --detach "$dir" 26f0bb0e && git -C "$dir" apply "$base/noA-final.patch"; } || exit 1
    (cd "$dir" && ~/buster-fast-bench/exclusive.sh timeout 1500 env BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$offset ./build.sh > "$base/build-head2-o$offset.log" 2>&1)
    echo "build head2-o$offset status $?" >> "$base/placements.log"
    cp -f "$dir/build/compiler" "$base/bin/compiler-head2-o$offset"
done
(cd "$base/head2" && ~/buster-fast-bench/exclusive.sh timeout 1500 ./build.sh > "$base/build-head2b.log" 2>&1)
echo "build head2 status $?" >> "$base/placements.log"
cp -f "$base/head2/build/compiler" "$base/bin/compiler-head2"
"$base/abtr2.sh" p2 3 3 3 "0 1040 2080" main:main head:head head2:head2 main-again:main
echo done > "$base/head2-placements.done"

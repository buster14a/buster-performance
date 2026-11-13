#!/bin/bash
# r2-chain.sh: #892's second round. Main 447192ef (tree m2) and main with r2.patch (tree h3): builds, objects, counters
# and LBR, then each at checker offsets 1040 and 2080, then ab --lock of time-runs over the three placements.
set -u
base=~/buster-fast-bench/892-claude
commit=447192ef
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites, round 2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
cd "$base" || exit 2
git -C repo fetch -q origin main || exit 1
for tree in m2 h3; do
    if [ ! -d "$tree" ]; then
        git -C repo worktree add -q --detach "../$tree" "$commit" || exit 1
    fi
done
(cd h3 && git checkout -q -- . && git apply "$base/r2.patch") || exit 1
for tree in m2 h3; do
    ./build.sh "$tree"
    grep -q "build $tree status 0" "build-$tree.log" || { echo "build $tree failed" > r2-chain.failed; exit 1; }
done
rm -f results/objects.done
./objects.sh m2 h3 > objects-r2.log 2>&1
./lbr.sh m2 > lbr-m2.log 2>&1
./lbr.sh h3 > lbr-h3.log 2>&1
for offset in 1040 2080; do
    for tree in m2 h3; do
        dir=$base/$tree-o$offset
        if [ ! -d "$dir" ]; then
            git -C repo worktree add -q --detach "$dir" "$commit" || exit 1
            if [ "$tree" = h3 ]; then
                git -C "$dir" apply "$base/r2.patch" || exit 1
            fi
        fi
        (cd "$dir" && ~/buster-fast-bench/exclusive.sh timeout 1500 env BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$offset ./build.sh > "$base/build-$tree-o$offset.log" 2>&1)
        echo "build $tree-o$offset status $?" >> "$base/placements-r2.log"
        cp -f "$dir/build/compiler" "$base/bin/compiler-$tree-o$offset"
    done
done
./abtr2.sh r2 3 3 3 "0 1040 2080" m2:m2 h3:h3 m2-again:m2
echo done > r2-chain.done

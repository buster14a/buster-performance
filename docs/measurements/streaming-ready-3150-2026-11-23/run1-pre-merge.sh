#!/bin/bash
# #3150: benchmark-streaming, main against the branch, Release, under the 9700X lock.
set -u
cd ~/buster-fast-bench/3150-claude
export EXCLUSIVE_OWNER=claude-3150 EXCLUSIVE_TITLE="streaming ready word #3150" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3150
for tree in main branch; do
    if [ ! -d $tree ]; then git clone -q https://github.com/buster14a/buster $tree; fi
done
git -C main fetch -q origin main && git -C main checkout -q --detach 4704727a
git -C branch fetch -q origin claude/streaming-ready-3150 && git -C branch checkout -q --detach FETCH_HEAD
for tree in main branch; do
    (cd $tree && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-$tree.log 2>&1 || { echo build $tree failed; exit 1; }
done
for round in 1 2; do
    for tree in main branch; do
        for order in callees callers; do
            echo "== $tree $order serial round $round"
            ~/buster-fast-bench/exclusive.sh bash -c "cat /proc/loadavg; taskset -c 2 ./$tree/build/compiler benchmark-streaming --order $order --directory /tmp/3150-claude-$tree; cat /proc/loadavg"
            echo "== $tree $order writer round $round"
            ~/buster-fast-bench/exclusive.sh bash -c "cat /proc/loadavg; taskset -c 2,3 ./$tree/build/compiler benchmark-streaming --order $order --lanes 2 --cpus 2,3 --directory /tmp/3150-claude-$tree; cat /proc/loadavg"
        done
    done
done
echo DONE

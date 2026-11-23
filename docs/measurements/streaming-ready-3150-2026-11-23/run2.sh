#!/bin/bash
# #3150 / PR #3350: benchmark-streaming, main (merge's first parent) against the PR's merged head, Release, under the
# 9700X lock, one hold per run. Usage: run2.sh MAIN_SHA BRANCH_SHA
set -u
main_sha=$1
branch_sha=$2
cd ~/buster-fast-bench/3150-claude
out=results2
mkdir -p $out
export EXCLUSIVE_OWNER=claude-3150-pr3350 EXCLUSIVE_TITLE="PR 3350 streaming ready word" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3350
git -C main fetch -q origin main && git -C main checkout -q --detach $main_sha || exit 1
git -C branch fetch -q origin claude/streaming-ready-3150 && git -C branch checkout -q --detach $branch_sha || exit 1
for tree in main branch; do
    (cd $tree && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > $out/build-$tree.log 2>&1 || { echo build $tree failed; exit 1; }
done
busy='cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8'
for round in 1 2 3; do
    for tree in main branch; do
        for order in callees callers; do
            echo "== $tree $order writer round $round"
            ~/buster-fast-bench/exclusive.sh bash -c "$busy; taskset -c 2,3 ./$tree/build/compiler benchmark-streaming --order $order --lanes 2 --cpus 2,3 --directory /tmp/3150-claude-$tree; $busy"
        done
    done
done
echo DONE

#!/bin/bash
# The whole record on the 9700X from tmpfs (/home was full on 2026-11-22): the tree at the pull request's head, its
# Release build under the lock, the kernels, the corpora's steps and the programs. Each is one hold of the lock.
W=/dev/shm/3309-fable
REVISION=f16b0523aba9b13129bdbd44790858d2df57d396
cd $W || exit 1
mkdir -p logs
export EXCLUSIVE_OWNER=claude-3309-fable EXCLUSIVE_TITLE='buster #3309: loop store motion (build)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3328
if [ ! -d tree ]; then
    git clone -q --no-hardlinks $HOME/buster-fast-bench/3309-claude/tree tree > logs/clone.txt 2>&1 || { echo "clone failed" >> logs/queue.txt; exit 1; }
fi
(cd tree && git fetch -q https://github.com/buster14a/buster claude/vibrant-shannon-198lwc && git checkout -q --detach $REVISION && git status --short | wc -l && git log --oneline -1) >> logs/clone.txt 2>&1 || { echo "fetch failed" >> logs/queue.txt; exit 1; }
$HOME/buster-fast-bench/exclusive.sh bash -c "cd $W/tree && BUSTER_DEBUG_INFO=0 ./build.sh --config Release" > logs/build.txt 2>&1
echo "build exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
[ -x tree/build/compiler ] || exit 1
./sm3309-kernels.sh
echo "kernels exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
./sm3309-measure.sh corpora programs

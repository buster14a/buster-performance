#!/bin/bash
# #1629, second part: fetches main at 6c8b058993b97b868a3655805f600016e9849028, then builds, each in a lock hold of its own, with the harness that can time the
# object stage again warm, call by call (scripts-w: EMIT_AB_OBJECT_WARM=N, EMIT_AB_OBJECT_REPEAT): main418w (3bfb4a72), mainw
# (main at 6c8b058993b97b868a3655805f600016e9849028, after #1658) and c7w (mainw with patches/c7.patch, the class sections' names' lengths as constants).
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
git -C buster.git fetch -q origin main 2>&1 | tail -2
git -C buster.git cat-file -t 6c8b058993b97b868a3655805f600016e9849028
LOCK=$HOME/buster-fast-bench/exclusive.sh scripts-w/build-trees.sh buster.git trees main418w=3bfb4a72a51f4a7872090905d52f92b95b3e1375:old mainw=6c8b058993b97b868a3655805f600016e9849028:now c7w=6c8b058993b97b868a3655805f600016e9849028:now:$PWD/patches/c7.patch
for t in main418w mainw c7w; do ls -la trees/$t/build/compiler; done
echo setup2-done

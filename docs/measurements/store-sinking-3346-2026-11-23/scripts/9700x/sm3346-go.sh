#!/bin/bash
# #3346 on the 9700X, from /tmp (/home is full): the Release builds of this branch (tree) and of #3328's head (base),
# each in one hold of the lock; then the kernels and the compile times, each in one hold.
W=/tmp/3346-claude
cd $W || exit 1
mkdir -p logs
export EXCLUSIVE_OWNER=claude-3346 EXCLUSIVE_TITLE='buster #3346: loop store motion sinks stores (build)' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnh2KB6UMiNcgm6mK5q
L=$HOME/buster-fast-bench/exclusive.sh
for t in tree base; do
    [ -x $t/build/compiler ] && [ "${REBUILD:-0}" = 0 ] && continue
    timeout 3000 $L bash -c "cd $W/$t && git log --oneline -1 && BUSTER_DEBUG_INFO=0 ./build.sh --config Release" > logs/build-$t.txt 2>&1
    echo "build $t exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
done
[ -x tree/build/compiler ] && [ -x base/build/compiler ] || exit 1
timeout 3000 ./sm3346-kernels.sh
echo "kernels exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
timeout 3000 ./sm3346-compile.sh
echo "compile exit $? $(date -u +%FT%TZ)" >> logs/queue.txt

#!/bin/bash
# #1840 family B: the Zen 5 rows of vextracti32x4, vextracti64x4, vinserti32x4 and vinserti64x4 (register forms), which
# Tier 1's width changes emit: main cb608c1 with the family's working patch, built (znver5), then measure-x86-zen5
# --missing --table pinned to CPU 2. One hold each.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations: width changes (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
X=~/buster-fast-bench/exclusive.sh
[ -d zen5 ] || git -C repo worktree add -q --detach ../zen5 cb608c1
git -C zen5 checkout -q -- . && git -C zen5 apply $D/familyb.patch && echo applied > zen5.log
$X sh -c 'cd zen5 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' >> zen5.log 2>&1
echo "build exit $?" >> zen5.log
$X taskset -c 2 zen5/build/compiler measure-x86-zen5 --missing --table > zen5-table.txt 2> zen5-errors.txt
echo "measure exit $?" >> zen5.log
touch zen5.done

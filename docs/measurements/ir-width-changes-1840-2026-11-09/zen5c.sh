#!/bin/bash
# #1840 family C: the Zen 5 rows of vpermb, vpermw, vpermd, vpermq, vpshufb, valignd, valignq and vshufi64x2 (register forms), which
# Tier 1's permutes emit: main cb608c1 with the family's working patch, built (znver5), then measure-x86-zen5
# --missing --table pinned to CPU 2. One hold each.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations: permutes (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
X=~/buster-fast-bench/exclusive.sh
[ -d zen5 ] || git -C repo worktree add -q --detach ../zen5 cb608c1
git -C zen5 checkout -q -- . && git -C zen5 apply $D/familyc.patch && echo applied > zen5c.log
$X sh -c 'cd zen5 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' >> zen5c.log 2>&1
echo "build exit $?" >> zen5c.log
$X taskset -c 2 zen5/build/compiler measure-x86-zen5 --missing --table > zen5c-table.txt 2> zen5c-errors.txt
echo "measure exit $?" >> zen5c.log
touch zen5c.done

#!/bin/bash
# #1840 family D: the Zen 5 rows of vpmovzx, vpmovsx, vpmov, vpmovs and vpmovus (register forms), which
# Tier 1's conversions emit: main cb608c1 with the family's working patch, built (znver5), then measure-x86-zen5
# --missing --table pinned to CPU 2. One hold each.
set -u
D=~/buster-fast-bench/1840-claude
cd $D
export EXCLUSIVE_OWNER=claude-1840 EXCLUSIVE_TITLE='Decode SIMD machine rows into IR operations: conversions (#1840)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
X=~/buster-fast-bench/exclusive.sh
[ -d zen5 ] || git -C repo worktree add -q --detach ../zen5 cb608c1
git -C zen5 checkout -q -- . && git -C zen5 clean -qfd && git -C zen5 apply $D/familyd.patch && echo applied > zen5d.log
$X sh -c 'cd zen5 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' >> zen5d.log 2>&1
echo "build exit $?" >> zen5d.log
$X taskset -c 2 zen5/build/compiler measure-x86-zen5 --missing --table > zen5d-table.txt 2> zen5d-errors.txt
echo "measure exit $?" >> zen5d.log
touch zen5d.done

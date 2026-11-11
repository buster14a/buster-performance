#!/bin/sh
D=~/buster-fast-bench/1840-claude-b3
S=~/buster-fast-bench/1840-claude-b3-scripts
cd $D && git fetch -q origin ir/1840-third-operand && git checkout -q -f FETCH_HEAD && git rev-parse HEAD > $S/permute2.commit
export EXCLUSIVE_OWNER=claude-b3-1840 EXCLUSIVE_TITLE="B3 #1840 permute2 Zen5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > $S/permute2-build.log 2>&1
echo build=$? >> $S/permute2-build.log
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $S/permute2-table.txt 2> $S/permute2-errors.txt
echo measure=$? >> $S/permute2-errors.txt

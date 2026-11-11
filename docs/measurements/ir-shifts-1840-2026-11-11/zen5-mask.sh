#!/bin/sh
D=~/buster-fast-bench/1840-claude-b3
S=~/buster-fast-bench/1840-claude-b3-scripts
cd $D && git fetch -q origin ir/1840-mask-vectors && git checkout -q -f FETCH_HEAD && git rev-parse HEAD > $S/mask.commit
export EXCLUSIVE_OWNER=claude-b3-1840 EXCLUSIVE_TITLE="B3 #1840 mask conversions Zen5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > $S/mask-build.log 2>&1
echo build=$? >> $S/mask-build.log
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $S/mask-table.txt 2> $S/mask-errors.txt
echo measure=$? >> $S/mask-errors.txt

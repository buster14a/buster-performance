#!/bin/sh
# buster#1840: the byte shuffles by an immediate's 15 Zen 5 rows (measure-x86-zen5 --missing --table).
D=~/buster-fast-bench/1840-claude-g1
S=~/buster-fast-bench/1840-claude-g1-scripts
[ -d $D ] || git clone -q https://github.com/buster14a/buster.git $D
cd $D && git fetch -q origin claude/trusting-thompson-ye0dvx && git checkout -q -f FETCH_HEAD && git rev-parse HEAD > $S/shuffle.commit
export EXCLUSIVE_OWNER=claude-1840-g1 EXCLUSIVE_TITLE="#1840 byte shuffles by an immediate: Zen 5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > $S/shuffle-build.log 2>&1
echo build=$? >> $S/shuffle-build.log
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $S/shuffle-table.txt 2> $S/shuffle-errors.txt
echo measure=$? >> $S/shuffle-errors.txt

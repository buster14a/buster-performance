#!/bin/sh
# buster#1840: the bit shuffles' and quadword operations' 12 Zen 5 rows (measure-x86-zen5 --missing --table), at the
# local commit 6df967dc that the g2.bundle beside this script carries.
D=~/buster-fast-bench/1840-claude-g1
S=~/buster-fast-bench/1840-claude-g2-scripts
cd $D && git fetch -q $S/g2.bundle g2-measure && git checkout -q -f 6df967dc && git rev-parse HEAD > $S/rows.commit
export EXCLUSIVE_OWNER=claude-1840-g2 EXCLUSIVE_TITLE="#1840 bit shuffles and quadword operations: Zen 5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/rows-holds.txt; exec ./build.sh" > $S/rows-build.log 2>&1
echo build=$? >> $S/rows-build.log
sha256sum build/compiler > $S/rows-binary.txt
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/rows-holds.txt; exec taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table" > $S/rows-table.txt 2> $S/rows-errors.txt
echo measure=$? >> $S/rows-errors.txt

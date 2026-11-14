#!/bin/sh
# buster#1840: the funnel shifts' and rotates' 36 Zen 5 rows (measure-x86-zen5 --missing --table), at the local commit
# 2f6fb2ef that the g4.bundle beside this script carries.
D=~/buster-fast-bench/1840-claude-g1
S=~/buster-fast-bench/1840-claude-g3-scripts
cd $D && git fetch -q $S/g4.bundle g2-measure && git checkout -q -f 2f6fb2ef && git rev-parse HEAD > $S/rows.commit
export EXCLUSIVE_OWNER=claude-1840-g3 EXCLUSIVE_TITLE="#1840 funnel shifts and rotates: Zen 5 rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/rows-holds.txt; exec ./build.sh" > $S/rows-build.log 2>&1
echo build=$? >> $S/rows-build.log
sha256sum build/compiler > $S/rows-binary.txt
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> $S/rows-holds.txt; exec taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table" > $S/rows-table.txt 2> $S/rows-errors.txt
echo measure=$? >> $S/rows-errors.txt

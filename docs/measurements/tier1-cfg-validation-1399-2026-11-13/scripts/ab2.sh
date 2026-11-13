#!/bin/sh
# #1399: main, the first commit (head) and the fix (head2) on the 9700X, three-way interleaved rounds.
D=~/buster-fast-bench/1399-claude; cd $D; echo $$ > ab2.pid; R=$D/ab2.txt; rm -f $R
H2=b27b69d8b80cf258eae8a320e44d776fcf7ff01b
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 validation from the position column" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1399
[ -d head2 ] || git clone -q https://github.com/buster14a/buster head2
git -C head2 fetch -q origin claude/peaceful-mccarthy-x5dbp2; git -C head2 checkout -q -f $H2; git -C head2 rev-parse HEAD > head2/COMMIT
echo "base $(cat base/COMMIT) head $(cat head/COMMIT) head2 $(cat head2/COMMIT)" >> $R
(cd head2 && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-head2.log 2>&1) || { echo "build failed" >> $R; tail -20 build-head2.log >> $R; echo DONE >> $R; exit 1; }
sha256sum base/build/compiler head/build/compiler head2/build/compiler >> $R
ARGS="-c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c"
cat > round2.sh <<B
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | tail -3; cat /proc/loadavg
for r in \$@; do taskset -c 2 perf stat -x, -r 5 -e instructions:u,cycles:u,task-clock ./\$r/build/compiler $ARGS -o /dev/null 2> stat-\$r.tmp; echo "\$r \$(tr '\n' ' ' < stat-\$r.tmp)"; done
cat /proc/loadavg
B
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 ./head2/build/compiler $ARGS -o head2.sqlite.o" >> $R 2>&1
cmp base.sqlite.o head2.sqlite.o && echo "head2 sqlite3.c --tier1 --lanes=1 object identical to base" >> $R || echo "head2 object DIFFERS" >> $R
for i in 1 2 3 4 5 6; do case $((i % 3)) in 1) o="base head head2";; 2) o="head2 base head";; 0) o="head head2 base";; esac; echo "round $i" >> $R; ~/buster-fast-bench/exclusive.sh sh round2.sh $o >> $R 2>&1; done
cd head2; t() { name=$1; shift; ~/buster-fast-bench/exclusive.sh timeout -k 5 600 "$@" > ../t2_$name.log 2>&1 && echo "$name ok: $(grep -E 'checks|failures' ../t2_$name.log | tail -1 | cut -c1-200)" >> $R || { echo "$name FAIL: $(tail -2 ../t2_$name.log | cut -c1-300)" >> $R; }; }
t tier1-cfg ./build/compiler test-tier1-cfg
t tier1-emit ./build/compiler test-tier1-emit
echo DONE >> $R

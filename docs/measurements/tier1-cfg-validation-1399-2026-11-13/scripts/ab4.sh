#!/bin/sh
# #1399 after merging main, Release builds (build.sh now defaults to Develop): main 437ccbbc against the merged head fec9f8d2.
D=~/buster-fast-bench/1399-claude; cd $D; echo $$ > ab4.pid; R=$D/ab4.txt; rm -f $R
M=437ccbbc3b578d724d86139cc3ffa09e61fef390; H=fec9f8d2103614ac7ab62924716f8bf7354a207e
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 validation from the position column" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2689
for t in main-437ccbbc:$M merged-fec9f8d2:$H; do d=${t%%:*}; c=${t#*:}; [ -d $d ] || git clone -q https://github.com/buster14a/buster $d; git -C $d fetch -q origin main claude/peaceful-mccarthy-x5dbp2; git -C $d checkout -q -f $c; git -C $d rev-parse HEAD > $d/COMMIT; done
echo "main $(cat main-437ccbbc/COMMIT) merged $(cat merged-fec9f8d2/COMMIT)" >> $R
for d in main-437ccbbc merged-fec9f8d2; do (cd $d && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > ../build-$d.log 2>&1) || { echo "build failed $d" >> $R; tail -5 build-$d.log >> $R; echo DONE >> $R; exit 1; }; done
sha256sum main-437ccbbc/build/compiler merged-fec9f8d2/build/compiler >> $R; for d in main-437ccbbc merged-fec9f8d2; do grep -m1 "Release: " build-$d.log >> $R; readlink -f $d/build/compiler | sed "s|.*/build/|build/|" >> $R; done
ARGS="-c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c"
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 ./main-437ccbbc/build/compiler $ARGS -o main4.sqlite.o && taskset -c 2 ./merged-fec9f8d2/build/compiler $ARGS -o merged4.sqlite.o" >> $R 2>&1
cmp main4.sqlite.o merged4.sqlite.o && echo "merged sqlite3.c --tier1 --lanes=1 object identical to main" >> $R || echo "merged object DIFFERS" >> $R
cat > round4.sh <<B
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | tail -3; cat /proc/loadavg
for r in \$@; do taskset -c 2 perf stat -x, -r 5 -e instructions:u,cycles:u,task-clock ./\$r/build/compiler $ARGS -o /dev/null 2> stat-\$r.tmp; echo "\$r \$(tr '\n' ' ' < stat-\$r.tmp)"; done
cat /proc/loadavg
B
for i in 1 2 3 4 5 6; do if [ $((i % 2)) = 1 ]; then o="main-437ccbbc merged-fec9f8d2"; else o="merged-fec9f8d2 main-437ccbbc"; fi; echo "round $i" >> $R; ~/buster-fast-bench/exclusive.sh sh round4.sh $o >> $R 2>&1; done
cd merged-fec9f8d2; ~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build/compiler test-tier1-cfg > ../t4_tier1-cfg.log 2>&1 && echo "tier1-cfg ok: $(grep checks, ../t4_tier1-cfg.log | head -1 | cut -c1-120)" >> $R || echo "tier1-cfg FAIL" >> $R
echo DONE >> $R

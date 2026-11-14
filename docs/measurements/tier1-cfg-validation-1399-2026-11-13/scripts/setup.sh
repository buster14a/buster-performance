#!/bin/sh
# #1399: build main and profile -c --tier1 --lanes 1 of sqlite3.c on CPU 2.
D=~/buster-fast-bench/1399-claude; mkdir -p $D; cd $D; echo $$ > setup.pid; R=$D/profile.txt; rm -f $R
B=b7a95eed
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 interval searches" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1399
[ -d base ] || git clone -q https://github.com/buster14a/buster base
git -C base fetch -q origin main; git -C base checkout -q -f $B; git -C base rev-parse HEAD > base/COMMIT
(cd base && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-base.log 2>&1) || { echo "build failed" >> $R; tail -20 build-base.log >> $R; echo DONE >> $R; exit 1; }
cat > prof.sh <<B
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg
for i in 1 2 3 4 5; do s=\$(date +%s%N); taskset -c 2 ./base/build/compiler -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o base.sqlite.o; e=\$(( (\$(date +%s%N)-s)/1000 )); echo "run \$i \${e}us"; done
taskset -c 2 perf record -q -F 4999 -e cycles:u -o base.data ./base/build/compiler -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o /dev/null
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg
B
~/buster-fast-bench/exclusive.sh sh prof.sh >> $R 2>&1
perf report -i base.data --no-children --stdio -q --percent-limit 0.4 2>/dev/null | head -60 >> $R
echo DONE >> $R

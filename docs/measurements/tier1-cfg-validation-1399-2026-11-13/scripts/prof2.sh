#!/bin/sh
D=~/buster-fast-bench/1399-claude; cd $D; R=$D/profile2.txt; rm -f $R
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 interval searches" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1399
cat > rec.sh <<B
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4; cat /proc/loadavg
taskset -c 2 perf record -q -c 200003 -e cycles:u -o base2.data -- sh -c 'for i in 1 2 3 4 5 6 7 8 9 10; do ./base/build/compiler -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o /dev/null; done'
cat /proc/loadavg
B
~/buster-fast-bench/exclusive.sh sh rec.sh >> $R 2>&1
nice -n 19 perf report -i base2.data --no-children --stdio -q --sort sym --percent-limit 0.3 2>/dev/null | head -40 >> $R
echo "== srcline (tier1)" >> $R
nice -n 19 perf report -i base2.data --no-children --stdio -q --sort sym,srcline --percent-limit 0.01 2>/dev/null | grep -E "tier1_(cfg|emit_cfg|allocate)" > srclines.txt
echo DONE >> $R

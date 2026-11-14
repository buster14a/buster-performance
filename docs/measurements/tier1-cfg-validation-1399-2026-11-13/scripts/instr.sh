#!/bin/sh
# #1399: retired instructions by function, base and head, after ab.sh ends.
D=~/buster-fast-bench/1399-claude; cd $D; echo $$ > instr.pid; R=$D/instr.txt; rm -f $R
while kill -0 $(cat ab.pid) 2>/dev/null; do sleep 10; done
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
export EXCLUSIVE_OWNER=claude-1399 EXCLUSIVE_TITLE="#1399 Tier 1 validation from the position column" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1399
ARGS="-c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c"
~/buster-fast-bench/exclusive.sh sh -c "for r in base head; do taskset -c 2 perf record -q -c 20011 -e instructions:u -o \$r.i.data ./\$r/build/compiler $ARGS -o /dev/null; done" >> $R 2>&1
for r in base head; do nice -n 19 perf report -i $r.i.data --no-children --stdio -q --sort sym -F sample,sym 2>/dev/null | awk '{print $1, $3}' > $r.isyms.txt; done
join -1 2 -2 2 -a1 -a2 -e0 -o 0,1.1,2.1 <(sort -k2 base.isyms.txt) <(sort -k2 head.isyms.txt) | awk '{d=($3-$2)*20011; if (d>200000 || d<-200000) printf "%-50s %+.2fM\n", $1, d/1e6}' | sort -k2 -g >> $R
for r in base head; do echo "== $r tier1 srclines (instructions)" >> $R; nice -n 19 perf report -i $r.i.data --no-children --stdio -q --sort sym,srcline --symbols=tier1_cfg_prepare --percent-limit 0.02 2>/dev/null | head -25 >> $R; done
echo DONE >> $R

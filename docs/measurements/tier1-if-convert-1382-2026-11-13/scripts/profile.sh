#!/bin/bash
# perf profile of sqlite3.c's --tier1 -c by fab53452 and main (#1382's compile cost), one hold, CPU 2.
cd ~/buster-fast-bench/1382-claude/kernels
export EXCLUSIVE_OWNER=claude-1382 EXCLUSIVE_TITLE="#1382 Tier 1 if-conversion of nested, truth and reload regions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1382
s=$PWD/sqlite
cat > prof.sh <<P
head -1 /var/lib/buster-9700x/owner >> holds.txt
for b in main=../main-b7a95eed fixed=../head-fab53452; do
    n=\${b%%=*}; t=\${b#*=}
    taskset -c 2 perf record -q -c 200003 -e cycles:u -o perf-\$n.data \$t/build/compiler --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$s $s/sqlite3.c -o prof-\$n.o 2> /dev/null
done
P
~/buster-fast-bench/exclusive.sh timeout -k 5 120 bash prof.sh 2> prof-lock.log
for n in main fixed; do perf report -q -i perf-$n.data --no-children --sort symbol 2> /dev/null | head -40 > report-$n.txt; done
echo profiled

#!/usr/bin/env bash
# profile.sh BASE HEAD: on the 9700X, one hold, CPU 2: perf record of cycles:u over 5 runs of each tree's --tier1 -c of
# the frozen sqlite3.c, then each profile's symbols; outputs in stages-HEAD/.
. ~/buster-fast-bench/1116-claude/common.sh
base=$1
head=$2
out=$PWD/stages-$head
mkdir -p $out
"$lock" bash -c "for t in $base $head; do taskset -c 2 perf record -q -e cycles:u -c 200003 -o $out/perf-\$t.data -- bash -c 'for r in 1 2 3 4 5; do $PWD/'\$t'/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/profile.o $Q/sqlite3.c; done'; done"
for t in $base $head; do perf report -q -i $out/perf-$t.data --no-children --sort symbol --comm compiler -F overhead,sample,symbol 2> /dev/null | head -60 > $out/profile-$t.txt; done
echo "exit $?" > $out/profile.done

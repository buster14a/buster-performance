#!/bin/bash
# #1447 C2b (#2158): the SS template set's base and head trees (built by all.sh), -c of sqlite3.c and main.c, perf stat,
# 5 interleaved rounds pinned to CPU 2, each run under the lock on its own.
B=$HOME/buster-fast-bench/1447-c2b-claude; T=$B/trees; M=$B/m
export LC_ALL=C EXCLUSIVE_OWNER=claude-1447-c2b EXCLUSIVE_TITLE="#1447 C2b: %ss template set, base-vs-head -c perf stat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2158
X=$HOME/buster-fast-bench/exclusive.sh
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$CORPUS/sqlite $CORPUS/sqlite/sqlite3.c"
MAINC="-c -march=native -I$T/base/src -fwrapv -funsigned-char -fno-strict-aliasing $T/base/src/buster/compiler/main.c"
: > $M/perf.tsv
for round in 1 2 3 4 5; do for n in base ss; do for input in sqlite main; do
  args=$SQLITE; [ $input = main ] && args=$MAINC
  $X bash -c "perf stat -x, -e instructions:u,cycles:u,task-clock -o $M/one.csv taskset -c 2 $T/$n/build/compiler -o /tmp/1447-c2b-$input.o $args"
  echo "$round	$n	$input	$(grep -E 'instructions|cycles|task-clock' $M/one.csv | cut -d, -f1 | paste -sd'\t')" >> $M/perf.tsv
done; done; done
cat $M/perf.tsv; echo perf done

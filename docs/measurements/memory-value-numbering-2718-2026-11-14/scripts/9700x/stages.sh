#!/bin/bash
# stages.sh: the measured head's --tier1 compile of sqlite3.c with the pass (default) and without (--variant
# --tier1-passes=-memory), whole processes and per-stage medians, by measure-compile, pinned to CPU 2.
D=~/buster-fast-bench/2718-claude; R=$D/results/final; C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export EXCLUSIVE_OWNER=claude-2718 EXCLUSIVE_TITLE="#2718 memory value numbering" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2821
H=$D/head/build/compiler
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
unset CPATH C_INCLUDE_PATH
~/buster-fast-bench/exclusive.sh $D/held.sh $R/stages.txt timeout -k 5 1200 taskset -c 2 $H measure-compile --runs 11 --variant --tier1-passes=-memory -- --tier1 --lanes 1 $SQ -c $C/sqlite/sqlite3.c
echo done > $R/stages-done.txt

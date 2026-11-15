#!/bin/bash
# benchmark-tier1-select-source of sqlite3.c by main's and the head's compilers, alternating, three more runs each, one
# hold of the 9700X's lock per run, CPU 2.
set -u
cd ~/buster-fast-bench/2676-claude/compile
export EXCLUSIVE_OWNER=claude-2676 EXCLUSIVE_TITLE="#2676 Tier 1: a select of a comparison is cmp and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2676
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
t=~/buster-fast-bench/2676-claude
for i in 2 3 4; do
    for name in head main; do
        ~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; taskset -c 2 $t/$name/build/compiler benchmark-tier1-select-source $flags $sqlite/sqlite3.c" > select-$name-$i.txt 2>&1
    done
done
echo done > select-repeat.done

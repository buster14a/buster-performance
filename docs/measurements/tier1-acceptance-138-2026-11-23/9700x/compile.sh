#!/bin/bash
# compile.sh: src's -c of the frozen sqlite3.c with #136's flags by default and by --tier1 (measure-compile --runs 7
# --variant --tier1, as the 2026-11-12 evidence on #138 measured it), pinned to CPU 2, in one hold of the lock.
set -u
cd "$(dirname "$0")"
mkdir -p results
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p /tmp/claude-138-compile
cd /tmp/claude-138-compile
~/buster-fast-bench/138-claude-acceptance/lock.sh bash -c "head -3 /var/lib/buster-9700x/owner; taskset -c 2 $HOME/buster-fast-bench/138-claude-acceptance/src/build/compiler measure-compile --runs 7 --variant --tier1 -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c" > ~/buster-fast-bench/138-claude-acceptance/results/compile.txt 2>&1
echo "exit $?" >> ~/buster-fast-bench/138-claude-acceptance/results/compile.txt

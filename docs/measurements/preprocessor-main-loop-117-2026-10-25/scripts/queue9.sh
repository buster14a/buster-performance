#!/usr/bin/env bash
# A flat profile of cand-64e7910 on sqlite3.c, after queue8.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
while [ ! -e results/queue8.done ]; do sleep 20; done
./perfflat.sh cand-64e7910 sqlite results/flat-64e7910-sqlite --runs 101 > results/flat-64e7910-sqlite.txt 2>&1
echo done > results/queue9.done

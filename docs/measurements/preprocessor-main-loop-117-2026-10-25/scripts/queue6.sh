#!/usr/bin/env bash
# The system headers sqlite3.c includes, alone and math.h alone, on cand-d451fe6, after queue5.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
while [ ! -e results/queue5.done ]; do sleep 20; done
./sysprobe.sh cand-d451fe6 "$here/inputs/sys.c" --runs 21 > results/sys-d451fe6.txt 2>&1
./sysprobe.sh cand-d451fe6 "$here/inputs/math.c" --runs 21 > results/math-d451fe6.txt 2>&1
echo done > results/queue6.done

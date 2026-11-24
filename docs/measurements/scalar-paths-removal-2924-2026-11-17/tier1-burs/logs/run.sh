#!/bin/bash
# run.sh: #3493's gate: benchmark-tier1-select-source (selection's cycles per IR instruction, 21 passes, the
# per-function definitions checked first) of sqlite3.c and Lua by the base (f44baa726) and head znver5 Release
# binaries, alternating, two rounds, CPU 2. One locked run.
set -u
cd "$(dirname "$0")"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
L=$HOME/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
sha256sum compiler-base compiler-head
for round in 1 2; do
  for b in base head; do
    echo "== round $round $b sqlite"; taskset -c 2 ./compiler-$b benchmark-tier1-select-source -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c 2>&1 | grep -E 'bottom-up|^select|files='
    echo "== round $round $b lua"; taskset -c 2 ./compiler-$b benchmark-tier1-select-source $L/*.c 2>&1 | grep -E 'bottom-up|^select|files='
  done
done

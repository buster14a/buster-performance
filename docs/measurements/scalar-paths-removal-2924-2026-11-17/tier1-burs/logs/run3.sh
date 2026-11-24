#!/bin/bash
# run2.sh: #3493's gate after the review: benchmark-tier1-select-source (selection's ns per IR instruction, the
# per-function definitions checked first) of sqlite3.c and Lua by the base (main d6daf644d, the tree 831eeb5f6 merged) and the final head (48f5d1728, the slot table)
# znver5 Release binaries, alternating, three rounds, CPU 2. One locked run. (run2.sh read the reviewed head 0.37% slower; run.sh's run read nothing: the binaries
# had no execute bit.)
set -u
cd "$(dirname "$0")"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
L=$HOME/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
for b in base2 head3; do ./compiler-$b --version > /dev/null 2>&1 || { echo "compiler-$b does not run"; exit 1; }; done
sha256sum compiler-base2 compiler-head3
for round in 1 2 3; do
  for b in base2 head3; do
    echo "== round $round $b sqlite"; taskset -c 2 ./compiler-$b benchmark-tier1-select-source -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c > out.txt 2>&1; echo "exit $?"; grep -E 'bottom-up|^select|files=' out.txt
    echo "== round $round $b lua"; (cd $L && taskset -c 2 $OLDPWD/compiler-$b benchmark-tier1-select-source *.c) > out.txt 2>&1; echo "exit $?"; grep -E 'bottom-up|^select|files=' out.txt
  done
done

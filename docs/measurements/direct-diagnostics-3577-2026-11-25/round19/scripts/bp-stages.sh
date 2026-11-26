#!/bin/bash
# bp-stages.sh: measure-compile's full report (stages) of the work tree's compiler against main's (base), one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: stage times, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 21 --reference ../base/build/compiler -- "${flags[@]}" 2>&1
' x "$sqlite"
echo DONE

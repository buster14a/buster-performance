#!/bin/bash
# loop2.sh LABEL < PATCH: resets the work tree to 363094190, applies PATCH (a diff against it), builds Release and runs
# measure-compile's interleaved A/B against main (base) on sqlite3.c's default -c, in one locked run each.
label=$1
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/work" || exit 1
git checkout -q -- src tools docs 2>/dev/null
git checkout -q --detach 363094190 || exit 1
git apply --whitespace=nowarn - || { echo "PATCH FAILED"; exit 1; }
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: A/B of a variant ($label)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > ../work-build.log 2>&1 || { echo "BUILD FAILED"; tail -20 ../work-build.log; exit 1; }
./build/compiler --version > /dev/null || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  taskset -c 2 ./build/compiler measure-compile --runs 11 --reference ../base/build/compiler -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" 2>&1 | grep -E "^(default|compiler): median"
  taskset -c 2 ./build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o ../work-sqlite.o && sha256sum ../work-sqlite.o | cut -c1-16
' loop "$sqlite" | sed -e "s/^/$label: /" -e "s/ ms wall ([^)]*), [0-9.]* ms user, [0-9.]* ms system, [0-9]* KiB wait4 peak, [0-9]* minor faults, 0 major,/ ms wall,/"

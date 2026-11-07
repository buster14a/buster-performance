#!/bin/bash
# sqlite3.c -c with -flazy-system-headers (#155) against the default, measure-compile each under its own hold of the
# lock: what the opt-in skip of system bodies takes off the reader today (#529 work item 2).
set -u
base=~/buster-fast-bench/529-claude-galileo
out="$base/sysdecl"; cd "$out"
export EXCLUSIVE_OWNER=claude-529-galileo EXCLUSIVE_TITLE="#529 lazy system headers" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/529
ex=~/buster-fast-bench/exclusive.sh
compiler="$base/out-b5/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
$ex taskset -c 2 "$compiler" measure-compile --runs 11 -- -flazy-system-headers "${options[@]}" -o lazy.o > measure-lazy.txt 2>&1
$ex bash -c "taskset -c 2 \"$compiler\" -flazy-system-headers ${options[*]} -o lazy-object.o && taskset -c 2 \"$compiler\" ${options[*]} -o default-object.o && sha256sum lazy-object.o default-object.o > lazy-objects.sha"
echo done > LAZY-DONE

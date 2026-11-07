#!/bin/bash
# The reader's cost of sqlite3.c's system headers (#529's "skip system-header declarations nothing uses"): sqlite3.c
# preprocessed (-E), its system headers' lines alone (sysfilter.py), and measure-compile of an empty unit, of the
# system lines alone, and of the whole preprocessed unit, each under its own hold of the 9700X's lock.
set -u
base=~/buster-fast-bench/529-claude-galileo
out="$base/sysdecl"; mkdir -p "$out"; cd "$out"
export EXCLUSIVE_OWNER=claude-529-galileo EXCLUSIVE_TITLE="#529 system headers' reader cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/529
ex=~/buster-fast-bench/exclusive.sh
compiler="$base/out-b5/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
defines=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
$ex taskset -c 2 "$compiler" -E "${defines[@]}" "$sqlite/sqlite3.c" -o sq.i
python3 "$base/sysfilter.py" sq.i sys.i
: > empty.c
sha256sum "$compiler" sq.i sys.i > inputs.sha
for unit in empty.c sys.i sq.i; do
  $ex taskset -c 2 "$compiler" measure-compile --runs 11 -- -c "$unit" -o "$unit.o" > "measure-$unit.txt" 2>&1
done
$ex taskset -c 2 "$compiler" measure-compile --runs 11 -- -c "${defines[@]}" "$sqlite/sqlite3.c" -o sqlite3.o > measure-sqlite3.c.txt 2>&1
echo done > DONE

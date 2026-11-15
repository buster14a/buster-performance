#!/bin/bash
# ab-copies.sh BASE HEAD: as ab.sh, each build from three fresh copies of its executable (seven runs a copy), so that an
# executable's own page-cache state (its resident pages at exec) is no part of the comparison.
set -u
cd "$(dirname "$0")"
base=$1
head=$2
out=$PWD/results/ab-copies-$base-$head
mkdir -p "$out/work"
sha256sum "results/$base/compiler" "results/$head/compiler" > "$out/compilers.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'; taskset -c 2 '$PWD/results/$head/compiler' time-runs --runs 7 --warmups 1 --copies 3 --directory '$out/work' --build $base '$PWD/results/$base/compiler' --build $head '$PWD/results/$head/compiler' --list -c -o /dev/null -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-runs.txt' 2>&1; echo \"status \$?\" >> '$out/time-runs.txt'"
date -u +%FT%TZ > "$out/.done"

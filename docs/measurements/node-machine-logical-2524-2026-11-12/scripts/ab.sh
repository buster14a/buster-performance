#!/bin/bash
# ab.sh BASE HEAD: -c of the frozen sqlite3.c (the 9700X job's compile_time options) by results/BASE's and results/HEAD's
# compilers, whole processes in time-runs' Williams order, 21 runs each after 2 warm-ups, CPU 2, one hold of the lock.
# From the step 1 record's ab.sh.
set -u
cd "$(dirname "$0")"
base=$1
head=$2
out=$PWD/results/ab-$base-$head
mkdir -p "$out"
sha256sum "results/$base/compiler" "results/$head/compiler" > "$out/compilers.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'; taskset -c 2 '$PWD/results/$head/compiler' time-runs --runs 21 --warmups 2 --directory '$out/work' --build $base '$PWD/results/$base/compiler' --build $head '$PWD/results/$head/compiler' --list -c -o /dev/null -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-runs.txt' 2>&1; echo \"status \$?\" >> '$out/time-runs.txt'"
rm -rf "$out/work"
date -u +%FT%TZ > "$out/.done"

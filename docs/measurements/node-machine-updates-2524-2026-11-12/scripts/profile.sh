#!/bin/bash
# profile.sh LABEL: perf record of the shadow's sweeps on sqlite3.c with 40 passes by results/LABEL's compiler (CPU 2, one
# hold of the lock), and the report by symbol (step 1's profile.sh, without the build and the timing).
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/profile-holder.txt'
taskset -c 2 perf record -q -c 200003 -e cycles:u -o '$out/perf.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1
"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols.txt"
date -u +%FT%TZ > "$out/.profiled"

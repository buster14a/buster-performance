#!/bin/bash
# profile.sh LABEL: build src (one hold), time it as time.sh does (another hold), then perf record the sweeps on sqlite3.c
# with 40 passes (a third hold), and keep the report by symbol.
set -u
cd "$(dirname "$0")"
label=$1
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src && ./build.sh" > build-$label.log 2>&1
./time.sh "$label"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
./lock.sh bash -c "
taskset -c 2 perf record -q -c 200003 -e cycles:u -o '$out/perf.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1
"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols.txt"
date -u +%FT%TZ > "$out/.profiled"

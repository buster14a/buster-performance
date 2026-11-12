#!/bin/bash
# annotate.sh LABEL: perf record results/LABEL's compiler's sweeps on sqlite3.c (40 passes), by cycles and by retired
# instructions (one hold), then keep each report by symbol and its annotation of the machine's sweeps.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "
taskset -c 2 perf record -q -c 200003 -e cycles:u -o '$out/perf.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1
taskset -c 2 perf record -q -c 200003 -e instructions:u -o '$out/perf-instructions.data' '$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > /dev/null 2>&1
"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols.txt"
perf report -i "$out/perf-instructions.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-instructions-symbols.txt"
for s in node_machine_type node_machine_contexts node_machine_expand node_machine_action; do
    perf annotate -i "$out/perf.data" --stdio -s "$s" 2>/dev/null > "$out/annotate-$s.txt"
    perf annotate -i "$out/perf-instructions.data" --stdio -s "$s" 2>/dev/null > "$out/annotate-instructions-$s.txt"
done
date -u +%FT%TZ > "$out/.annotated"

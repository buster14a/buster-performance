#!/bin/bash
# #592: base against head, -c of the frozen sqlite3.c on CPU 2, under the 9700X's lock (one hold): ROUNDS rounds, each
# running every tree's compiler once with --time-stages in a rotating order, then perf stat's user instructions and
# cycles of each, interleaved. Usage: ab.sh OUT ROUNDS TREE...
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
out="$here/$1"
rounds=$2
shift 2
trees=("$@")
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
mkdir -p "$out"
for tree in "${trees[@]}"; do
    taskset -c 2 "$here/$tree/build/compiler" "${options[@]}" -o "$out/$tree.o"
    taskset -c 2 "$here/$tree/build/compiler" --scalar "${options[@]}" -o "$out/$tree-scalar.o"
done
sha256sum "$out"/*.o
count=${#trees[@]}
for round in $(seq 1 "$rounds"); do
    for k in $(seq 0 $((count - 1))); do
        tree=${trees[$(( (k + round) % count ))]}
        taskset -c 2 "$here/$tree/build/compiler" --time-stages "${options[@]}" -o "$out/run.o" 2> "$out/stages-$tree-$round.txt"
    done
done
for round in $(seq 1 "${PERF_ROUNDS:-3}"); do
    for k in $(seq 0 $((count - 1))); do
        tree=${trees[$(( (k + round) % count ))]}
        taskset -c 2 perf stat -x, -r 3 -e instructions:u,cycles:u -o "$out/stat-$tree-$round.txt" -- "$here/$tree/build/compiler" "${options[@]}" -o "$out/run.o"
    done
done
echo "ab done"

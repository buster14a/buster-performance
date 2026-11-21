#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1; ref=$2; control=${3:-prioron}
out=$PWD/results/$label/warnings
mkdir -p "$out"
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
root=$(mktemp -d /dev/shm/buster2850-warnings.XXXXXXXX)
trap 'rm -f "$root/sql.o"; rmdir "$root"' EXIT
for mode in "$control" off on; do
 opts=(); bin=$PWD/results/$label/compiler
 if [ "$mode" = "$control" ]; then bin=$PWD/results/$ref/compiler; fi
 if [[ "$mode" == on || "$mode" == prioron ]]; then opts=(--node-window); fi
 args=(-Wall -Wextra -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$root/sql.o")
 ./lock.sh bash -c 'out=$1; shift; taskset -c 2 "$@" > "$out.stdout" 2> "$out.stderr"' _ "$out/$mode" "$bin" "${opts[@]}" "${args[@]}" > "$out/$mode.lock" 2>&1
 sha256sum "$root/sql.o" | cut -d' ' -f1 > "$out/$mode.sha256"
done
for type in sha256 stdout stderr; do cmp "$out/off.$type" "$out/on.$type"; cmp "$out/$control.$type" "$out/on.$type"; done
echo COMPLETE

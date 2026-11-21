#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1
ref=$2
exec 8>our-timing.lock; flock -x 8
out=$PWD/results/$label/wall
mkdir -p "$out"
root=$(mktemp -d /dev/shm/buster2850-wall.XXXXXXXX)
trap 'rm -f "$root/sqlite3.o"; rmdir "$root"' EXIT
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for n in $(seq 1 7); do
    modes=(parent off on on off parent)
    if [ $((n%2)) = 0 ]; then modes=(on parent off off parent on); fi
    i=0
    for mode in "${modes[@]}"; do
        i=$((i+1)); tag="$mode-$n-$i"; bin=$PWD/results/$label/compiler
        [ "$mode" != parent ] || bin=$PWD/results/$ref/compiler
        args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$root/sqlite3.o")
        [ "$mode" != on ] || args=(--node-window "${args[@]}")
        rm -f "$root/sqlite3.o"
        ./lock.sh taskset -c 2 "$PWD/results/$label/compiler" time-runs --runs 1 --warmups 0 --executable "$bin" --list "${args[@]}" > "$out/$tag.log" 2>&1
        sha256sum "$root/sqlite3.o" | cut -d' ' -f1 > "$out/$tag.sha256"
    done
done
echo COMPLETE

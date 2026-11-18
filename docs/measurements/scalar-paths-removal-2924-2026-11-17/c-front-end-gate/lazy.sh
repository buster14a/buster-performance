#!/bin/bash
# #2924 C12's gate, the lazy planner: the gate's builds none and lazy (compiler-areas0, compiler-areas8) with
# -flazy-system-headers, where the planner runs: objects compared, then ab, three rounds, around time-runs (three runs)
# of sqlite3.c and Lua's units, -c --lanes 1, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the front end's gate (lazy planner)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$P/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
objects=/dev/shm/claude-2924-c12-lazy-objects
rm -rf "$objects"
for b in 0 8; do
    mkdir -p "$objects/$b/sqlite" "$objects/$b/lua"
    (cd "$objects/$b/sqlite" && $L timeout -k 5 1500 "$D/compilers/compiler-areas$b" -c --lanes 1 -flazy-system-headers --time-stages "${S[@]}" -o sqlite3.o > /dev/null 2> "$D/logs/lazy-stages-sqlite-$b.txt"); echo "lazy objects $b sqlite: $?" >> logs/status-lazy.txt
    (cd "$objects/$b/lua" && $L timeout -k 5 1500 "$D/compilers/compiler-areas$b" -c --lanes 1 -flazy-system-headers "$lua"/*.c > /dev/null 2>> "$D/logs/lazy-stderr-$b.txt"); echo "lazy objects $b lua: $?" >> logs/status-lazy.txt
done
n=0; d=0
while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/8/$f" || d=$((d+1)); done < <(cd "$objects/0" && find . -name '*.o' | sort)
echo "lazy objects: $n compared, $d differ" >> logs/status-lazy.txt
rm -rf "$objects"
out=/dev/shm/claude-2924-c12-lazy
for list in sqlite lua; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 -flazy-system-headers "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 -flazy-system-headers "$lua"/*.c);;
    esac
    (cd "$out" && "$D/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$out" --build none "$D/compilers/compiler-areas0" --build lazy "$D/compilers/compiler-areas8" --list "${args[@]}" > "$D/logs/time-lazy-$list.log" 2>&1)
    echo "time lazy $list: $?" >> logs/status-lazy.txt
done
rm -rf "$out"
echo done >> logs/status-lazy.txt

#!/bin/bash
# #2924 C12c-3 core-3: placement or executed code? (1) nm -S of base against area1 (the environment's patch), area5
# (the deferred merge's) and head: every symbol whose size or presence differs. (2) ab, three rounds, around time-runs
# (three runs of three copies) of base, area1, area5, head and base again on -c --lanes 1 of sqlite3.c, Lua's units and
# gate3's 256 groups' fixture: areas 1 and 5 change code these lists don't execute.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
P=$D/../c3pr
: > logs/placement-status.txt
mkdir -p logs/symbols
for b in base area1 area5 head; do nm -S compilers/$b | awk 'NF == 4 {print $4, strtonum("0x" $2)}' | sort > logs/symbols/$b.txt; done
for b in area1 area5 head; do
    join -a1 -a2 -e MISSING -o 0,1.2,2.2 logs/symbols/base.txt logs/symbols/$b.txt | awk '$2 != $3' > logs/symbols/diff-$b.txt
    echo "symbols base against $b: $(wc -l < logs/symbols/diff-$b.txt) differ" >> logs/placement-status.txt
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$P/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
F=$D/../c12k-gate3/fixtures/overloadable-256.c
out=/dev/shm/claude-2924-c12c33t
BUILDS=(--build base "$D/compilers/base" --build area1 "$D/compilers/area1" --build area5 "$D/compilers/area5" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite lua fixture; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        fixture) args=(-c --lanes 1 "$F" -o "$out/fixture.o");;
    esac
    (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/placement-time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/placement-status.txt
done
rm -rf "$out"
echo done >> logs/placement-status.txt

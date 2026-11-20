#!/bin/bash
# #2924 C12c-3 core-3: does base (844e73a12) or head (a16652352) stand apart? A clean Release build of their parent
# 88741d83b (whose production source is base's: 844e73a12 changes only a test), timed in the same ab as base, head and
# base again: three rounds of time-runs (three runs of three copies), on run.sh's six lists and on -c --lanes 1 of Lua's
# and musl's units with no warning option.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
: > logs/parent-status.txt
if [ ! -d src-parent ]; then git clone -q --shared $D/../c7gate/src src-parent || exit 1; fi
git -C src-parent fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/parent-status.txt; exit 1; }
git -C src-parent checkout -q --detach 88741d83b && git -C src-parent reset -q --hard && git -C src-parent clean -qfdx src
rm -rf src-parent/build
(cd src-parent && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-parent.log" 2>&1) || { echo "build parent failed" >> logs/parent-status.txt; exit 1; }
cp src-parent/build/compiler compilers/parent
echo "built parent $(git -C src-parent rev-parse --short HEAD)" >> logs/parent-status.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
W=(-Wall -Wextra)
F=$D/../c12k-gate3/fixtures/overloadable-256.c
out=/dev/shm/claude-2924-c12c33r
BUILDS=(--build base "$D/compilers/base" --build parent "$D/compilers/parent" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite-wall lua-wall musl-wall sqlite lua musl dsqlite fixture; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite-wall) args=(-c --lanes 1 "${W[@]}" "${S[@]}" -o "$out/sqlite3.o");;
        lua-wall) args=(-c --lanes 1 "${W[@]}" "$lua"/*.c);;
        musl-wall) args=(-c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}");;
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        dsqlite) args=(-c --lanes 4 --deferred-bodies "${S[@]}" -o "$out/sqlite3.o");;
        fixture) args=(-c --lanes 1 "$F" -o "$out/fixture.o");;
    esac
    if [ "$list" = dsqlite ]; then
        (cd "$out" && taskset -c 2-9 "$D/compilers/base" ab --rounds 3 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/parent-time-$list.log" 2>&1)
    else
        (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/parent-time-$list.log" 2>&1)
    fi
    echo "time $list: $?" >> logs/parent-status.txt
done
rm -rf "$out"
echo done >> logs/parent-status.txt

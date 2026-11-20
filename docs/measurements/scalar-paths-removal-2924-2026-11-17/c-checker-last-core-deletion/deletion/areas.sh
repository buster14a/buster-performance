#!/bin/bash
# #2924 C12c-3 core-3: which area's deletion makes head slower? Five Release builds, each base (844e73a12) with one
# area's part of the deletion (areas/N-*.diff: 1 the environment, 2 the overload index, 3 the mangling, 4 the
# unsequenced checks, 5 the deferred merge), built in one tree one after another; then ab, three rounds, around
# time-runs (three runs of three copies) of base, the five, head and base again on -c --lanes 1 of sqlite3.c, Lua's
# units, Lua's units with -Wall -Wextra, musl's units with -Wall -Wextra and gate3's 256 groups' fixture.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
: > logs/areas-status.txt
if [ ! -d src-area ]; then git clone -q --shared $D/../c7gate/src src-area || exit 1; fi
git -C src-area fetch -q "$D/core3.bundle" 'refs/heads/*:refs/remotes/bundle/*' 2>/dev/null || git -C src-area fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7
git -C src-area fetch -q "$D/core3.bundle" 'refs/heads/*:refs/remotes/bundle/*' || { echo "bundle failed" >> logs/areas-status.txt; exit 1; }
for n in 1 2 3 4 5; do
    git -C src-area checkout -q --detach 844e73a12 && git -C src-area reset -q --hard && git -C src-area clean -qfd src
    (cd src-area && git apply "$D/areas/$n-"*.diff) || { echo "apply $n failed" >> logs/areas-status.txt; exit 1; }
    (cd src-area && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-area$n.log" 2>&1) || { echo "build area$n failed" >> logs/areas-status.txt; exit 1; }
    cp src-area/build/compiler compilers/area$n
    echo "built area$n" >> logs/areas-status.txt
done
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
out=/dev/shm/claude-2924-c12c33s
BUILDS=(--build base "$D/compilers/base" --build area1 "$D/compilers/area1" --build area2 "$D/compilers/area2" --build area3 "$D/compilers/area3"
        --build area4 "$D/compilers/area4" --build area5 "$D/compilers/area5" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite lua lua-wall musl-wall fixture; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        lua-wall) args=(-c --lanes 1 "${W[@]}" "$lua"/*.c);;
        musl-wall) args=(-c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}");;
        fixture) args=(-c --lanes 1 "$F" -o "$out/fixture.o");;
    esac
    (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/areas-time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/areas-status.txt
done
rm -rf "$out"
echo done >> logs/areas-status.txt
